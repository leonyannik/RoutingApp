//
//  EnterLocationViewController.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/23/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit


class EnterLocationViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var titleLabel: UIView!
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
}
