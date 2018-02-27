//
//  DropDownTextField.swift
//  RoutingApp
//
//  Created by Leon Yannik Lopez Rojas on 2/25/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation
import UIKit

extension UITextFieldDelegate {
    func itemSelected(item: Any) {
        
    }
}

extension UITableViewController {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.tableView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.tableView.layer.mask = mask
    }
    
}

class DropDownTextField: UITextField {
    
    var autoCompleteData =  ["León", "Lalo", "Rodrigo", "Leonor", "Raúl", "Casandra", "Viridiana", "Sarah", "André", "Fernando", "Lituania", "Lorena", "Andrea", "Sarabia", "Lourdes", "Lambert", "Lulu", "Leonardo", "Lobo", "Labernto"]
    var itemsToShow = [String]()
    var tableViewController: UITableViewController?
    var maximumNumberOfItems = 10
    var selectedIndex = 0
    var theMainView = UIView()
    var recognizers = [UIGestureRecognizer]()
    @IBInspectable var numberOfItemsToShow: Int = 1
    @IBInspectable var seperatorColor : UIColor = UIColor(white: 0.95, alpha: 1.0)
    @IBInspectable var popoverBackgroundColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    var popoverSize: CGRect {
        let origin = self.convert(self.bounds.origin, to: theMainView)
        let rect = CGRect(x: origin.x, y: origin.y + self.frame.size.height, width: self.frame.size.width, height: CGFloat(numberOfItemsToShow * 44))
        return rect
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        print("Laying Out subvViews")
        if let textToLook = self.text, textToLook.count > 0, self.isFirstResponder {
            itemsToShow = applyFilterWithSearchQuery(textToLook)
            numberOfItemsToShow = itemsToShow.count
            print("Laying Out subvViews, and providing suggestions")
            self.provideSuggestions()
        } else {
            print("Laying Out subvViews, removing the table")
            if let table = self.tableViewController {
//                if table.tableView.superview != nil{
//                    table.tableView.removeFromSuperview()
//                    self.tableViewController = nil
//                }
            }
        }
    }

    
    func provideSuggestions(){
        if let tvc = self.tableViewController {
            self.tableViewController!.tableView.frame = self.popoverSize
            self.tableViewController!.roundCorners([.bottomLeft, .bottomRight], radius: 9)
            tableViewController!.tableView.reloadData()
        } else if numberOfItemsToShow > 0{
            print("There is no table, so it will be created")
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
            self.tableViewController = UITableViewController()
//            theMainView.addGestureRecognizer(tap)
            self.tableViewController!.tableView.delegate = self
            self.tableViewController!.tableView.dataSource = self
            self.tableViewController!.tableView.backgroundColor = self.popoverBackgroundColor
            self.tableViewController!.tableView.separatorColor = self.seperatorColor
            self.tableViewController!.tableView.frame = self.popoverSize
            self.tableViewController!.roundCorners([.bottomLeft, .bottomRight], radius: 9)
            theMainView.addSubview(tableViewController!.tableView)
            
            self.tableViewController!.tableView.alpha = 0.0
            UIView.animate(withDuration: 0.3,
                           animations: ({
                            self.tableViewController!.tableView.alpha = 1.0
                           }),
                           completion:{
                            (finished : Bool) in
                            
            })
        }
    }
    
    @objc func tapped (_ sender : UIGestureRecognizer!){
        if let table = self.tableViewController{
            if !table.tableView.frame.contains(sender.location(in: theMainView)) && self.isFirstResponder{
                self.resignFirstResponder()
                print("tapped is being called")
            }
        }
    }
    
    override func resignFirstResponder() -> Bool{
//        UIView.animate(withDuration: 0.3,
//                       animations: ({
//                        if let _ = self.tableViewController{
//                            self.tableViewController!.tableView.alpha = 0.0
//                        }
//                       }),
//                       completion:{
//                        (finished : Bool) in
//                        if let _ = self.tableViewController{
//                            self.tableViewController!.tableView.removeFromSuperview()
//                            self.tableViewController = nil
//                        }
//        })
//        print("Will handle exit")
        self.handleExit()
        return super.resignFirstResponder()
    }
    
    func handleExit(){
//        if let table = self.tableViewController{
////            table.tableView.reloadData()
////            table.tableView.removeFromSuperview()
            UIView.animate(withDuration: 0.3,
                                                  animations: ({
                                    if let _ = self.tableViewController{
                                        self.tableViewController!.tableView.alpha = 0.0
                                    }
                                   }),
                                   completion:{
                                    (finished : Bool) in
                                    if let _ = self.tableViewController{
                                        self.tableViewController!.tableView.removeFromSuperview()
                                        self.tableViewController = nil
                                    }
                    })
//        }
//        if numberOfItemsToShow > 0 {
//
//        }
//
    }
    
    func applyFilterWithSearchQuery(_ filter : String) -> [String] {
        let filteredData = autoCompleteData.filter({
            if let match: AnyObject = $0 as AnyObject?{
                return (match as! NSString).lowercased.hasPrefix((filter as NSString).lowercased)
                
            }
            else{
                return false
            }
        })
        numberOfItemsToShow = filteredData.count
        return filteredData
    }

}

extension DropDownTextField: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsToShow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MPGResultsCell")
        cell.backgroundColor = UIColor.clear
        let displayText : AnyObject? = itemsToShow[indexPath.row] as AnyObject?
        cell.textLabel!.text = displayText as! String
        return cell
    }
}


extension DropDownTextField: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath.row)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(selectedIndex, "a la hora de tocar el item")
        selectedIndex = indexPath.row
        print(selectedIndex, "a la ora de escoger el item")
        let displayText = itemsToShow[selectedIndex]
        self.text = displayText
        self.resignFirstResponder()
//        delegate?.itemSelected(item: autoCompleteData[indexPath.row])
    }
}



extension DropDownTextField: UIGestureRecognizerDelegate {
    
}
