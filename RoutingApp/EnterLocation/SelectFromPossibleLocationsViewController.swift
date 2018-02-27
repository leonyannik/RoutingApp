//
//  SelectFromPossibleLocationsViewController.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/27/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
//MARK: - Protocols
protocol SelectCorrectAddressDelegate {
    func selectedAddress(index: Int)
}

class SelectFromPossibleLocationsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants
    
    // MARK: - Variables
    var delegate: SelectCorrectAddressDelegate?
    var listOfAddresses = [String]()
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
}

// MARK: - Outlet Actions

// MARK: - Local Funtions
}
// MARK: -
// MARK: Extesions
// MARK: -
extension SelectFromPossibleLocationsViewController: UITableViewDataSource {
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAddresses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "possibleResultCell") as! PossibleResultTableViewCell
        if indexPath.row >= listOfAddresses.count {
            cell.addressLabel.text = "Non of the above"
        }else {
            cell.addressLabel.text = listOfAddresses[indexPath.row]
        }
        return cell
    }
}

extension SelectFromPossibleLocationsViewController: UITableViewDelegate {
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedAddress(index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
}
