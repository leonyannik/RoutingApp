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
    @IBOutlet weak var destinationFieldOne: UITextField!
    @IBOutlet weak var destinationFieldTwo: UITextField!
    
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        paintUserInterface()
        hideKeyboardWhenTappedAround()
        listenToKeyboardPop()
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Outlet Actions
    @IBAction func makeTheRouteButtonTapped(_ sender: Any) {
        
        
    }
    @IBAction func switchButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Local Funtions
    func paintUserInterface() {
        for button in enterButtonsGroup {
            button.layer.cornerRadius = 9
            button.backgroundColor = .black
            button.setTitleColor(.darkGray, for: .normal)
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
}
// MARK: -
// MARK: Extesions
// MARK: -
 extension EnterLocationViewController: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension EnterLocationViewController: CLLocationManagerDelegate {
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

