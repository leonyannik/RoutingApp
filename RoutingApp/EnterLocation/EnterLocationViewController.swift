//
//  EnterLocationViewController.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/23/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EnterLocationViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var enterButtonsGroup: [UIButton]!
    @IBOutlet weak var makeTheRouteButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var destinationFieldOne: DropDownTextField!
    @IBOutlet weak var destinationFieldTwo: UITextField!
    
    
    // MARK: - Constants
    let locationManager = CLLocationManager()
    // MARK: - Variables
    var myLocationTuples = [(locationText: String, mapItem: MKMapItem)]()
    var locationTuples = [(locationField: UITextField, mapItem: MKMapItem?)]()
    var listOfPossibleAddresses = [String]()
    var middleButtonTapped = true
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        paintUserInterface()
        hideKeyboardWhenTappedAround()
        listenToKeyboardPop()
        scrollView.delaysContentTouches = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
        locationTuples = [(sourceField, nil), (destinationFieldOne, nil), (destinationFieldTwo, nil)]
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowDirectionsSegue" {
            
        }else if segue.identifier == "toShowPossibleResultsSegue" {
            let controller = segue.destination as! SelectFromPossibleLocationsViewController
            controller.listOfAddresses = listOfPossibleAddresses
            controller.delegate = self
        }
    }
    
    // MARK: - Outlet Actions
    @IBAction func makeTheRouteButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toShowDirectionsSegue", sender: nil)
        
        
    }
    @IBAction func switchButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func destinationOneEnterButtonTapped(_ sender: Any) {
        view.endEditing(true)
        middleButtonTapped = true
        CLGeocoder().geocodeAddressString(destinationFieldOne.text!) { (placemarks, error) in
            self.listOfPossibleAddresses = []
            guard let placeMarks = placemarks else { return }
            for placeMark in placeMarks {
                self.listOfPossibleAddresses.append(self.formatAddressFromPlaceMark(placeMark: placeMark))
            }
            self.performSegue(withIdentifier: "toShowPossibleResultsSegue", sender: nil)
        }
    }
    
    @IBAction func destinationTwoEnterButtonTapped(_ sender: Any) {
        middleButtonTapped = false
        CLGeocoder().geocodeAddressString(destinationFieldTwo.text!) { (placemarks, error) in
            self.listOfPossibleAddresses = []
            guard let placeMarks = placemarks else { return }
            for placeMark in placeMarks {
                self.listOfPossibleAddresses.append(self.formatAddressFromPlaceMark(placeMark: placeMark))
            }
            self.performSegue(withIdentifier: "toShowPossibleResultsSegue", sender: nil)
        }
    }
    
    
    // MARK: - Local Funtions
    func paintUserInterface() {
        for button in enterButtonsGroup {
            button.layer.cornerRadius = 9
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
        }
        makeTheRouteButton.layer.cornerRadius = 9
        makeTheRouteButton.backgroundColor = .orange
        makeTheRouteButton.setTitleColor(.darkGray, for: .normal)
        
    }
    
    func listenToKeyboardPop() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            scrollView.scrollRectToVisible(CGRect(x: 0, y: keyboardViewEndFrame.height, width: 1, height: keyboardViewEndFrame.height), animated: true)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func formatAddressFromPlaceMark(placeMark: CLPlacemark) -> String {
        let locality = placeMark.locality // is the Colonia
        let name = placeMark.name
        let postalCode = placeMark.postalCode
        let country = placeMark.country
        let subLocality = placeMark.subLocality
        let adm = placeMark.administrativeArea
        let sub = placeMark.subAdministrativeArea
        let areasOfInterest = placeMark.areasOfInterest
        guard let test = placeMark.addressDictionary!["FormattedAddressLines"] as? [String] else { print("fail to retreive address"); return "nothing" }
        var secondTest = test.joined(separator: ", ")
        print(secondTest)
        print(name,locality, subLocality, country, postalCode, adm, sub)
        print(areasOfInterest)
        return secondTest
    }
}
// MARK: -
// MARK: Extesions
// MARK: -
 extension EnterLocationViewController: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func itemSelected(item: Any) {
        print(item)
    }
}

extension EnterLocationViewController: CLLocationManagerDelegate {
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!) { (CoreLlocationPlacemarks, error) in
            if let placeMarks = CoreLlocationPlacemarks {
                guard let placeMark = placeMarks.first else { return }
                let MapKlitPlaceMark = MKPlacemark(placemark: placeMark)
                self.locationTuples[0].mapItem = MKMapItem(placemark: MapKlitPlaceMark)
                self.sourceField.text = self.formatAddressFromPlaceMark(placeMark: placeMark)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension EnterLocationViewController: SelectCorrectAddressDelegate {
    func selectedAddress(index: Int) {
        if index < listOfPossibleAddresses.count {
            if middleButtonTapped {
                destinationFieldOne.text = listOfPossibleAddresses[index]
            }else {
                destinationFieldTwo.text = listOfPossibleAddresses[index]
            }
        }else {
            print("Non was selected")
        }
    }
}

