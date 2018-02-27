//
//  DisplayDirectionsViewController.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/23/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DisplayDirectionsViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: - Constants
    
    // MARK: - Variables
    var totalTime = 0
    var totalTimeToBeDisplayed: String {
        return String(totalTime)
    }
    var mapKitItems = [MKMapItem]()
    var routsByPlace = [MKRoute]()
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        calculateSegmentDirections(index: 0, time: 0, routes: [])
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Outlet Actions
    
    // MARK: - Local Funtions
    func calculateSegmentDirections(index: Int, time: TimeInterval, routes: [MKRoute]) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = mapKitItems[index]
        request.destination = mapKitItems[index+1]
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let routeResponse = response?.routes {
                var timeVar = time
                var routesVar = routes
                let quickestRouteForSegment: MKRoute = routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0]
                routesVar.append(quickestRouteForSegment)
                timeVar += quickestRouteForSegment.expectedTravelTime
                if index + 2 < self.mapKitItems.count {
                    self.calculateSegmentDirections(index: index + 1, time: timeVar, routes: routesVar)
                    self.routsByPlace.append(quickestRouteForSegment)
                }else {
                    self.routsByPlace.append(quickestRouteForSegment)
                    timeVar += quickestRouteForSegment.expectedTravelTime
                    self.showRoute(routes: routesVar)
                    self.tableView.reloadData()
                    self.totalTimeLabel.text = "Total time: \(timeVar)"
                }
            }else if let _ = error {
                let alert = UIAlertController(title: nil, message: "Directions not available.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel) { (alert) -> Void in self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func plotPolyline(route: MKRoute) {
        mapView.add(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        }else {
            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect, route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        }
    }
    
    func showRoute(routes: [MKRoute]) {
        for i in 0..<routes.count {
            plotPolyline(route: routes[i])
        }
    }
}
// MARK: -
// MARK: Extesions
// MARK: -
extension DisplayDirectionsViewController: MKMapViewDelegate {
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor =
                    UIColor.blue.withAlphaComponent(0.60)
            } else if mapView.overlays.count == 2 {
                polylineRenderer.strokeColor =
                    UIColor.green.withAlphaComponent(0.60)
            } else if mapView.overlays.count == 3 {
                polylineRenderer.strokeColor =
                    UIColor.red.withAlphaComponent(0.60)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
}

extension DisplayDirectionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return routsByPlace.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routsByPlace[section].steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directionCell") as! DirectionTableViewCell
        cell.directionsLabel.text =  routsByPlace[indexPath.section].steps[indexPath.row].instructions
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mapKitItems[section].name
    }
}

extension DisplayDirectionsViewController: UITableViewDelegate {
}
