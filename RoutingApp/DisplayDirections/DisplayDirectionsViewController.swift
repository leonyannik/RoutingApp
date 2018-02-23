//
//  DisplayDirectionsViewController.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/23/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import MapKit

class DisplayDirectionsViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Outlet Actions
    
    // MARK: - Local Funtions
}
