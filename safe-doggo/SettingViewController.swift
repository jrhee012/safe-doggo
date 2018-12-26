//
//  SettingViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/23/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var unitsTableView: UITableView!
    
//    var unitsChecked: [Bool]!
    var unitsData = ["Imperial (˚F)", "Metric (˚C)"]
    let unitsTableCellIdentifier = "unitsCell"
    var unitChecked = "imperial"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Setting"
        
//        unitsChecked = [Bool](repeating: false, count: self.unitsData.count)
//        unitsChecked[0] = true
        
        unitsTableView.tag = 0
        unitsTableView.dataSource = self
        unitsTableView.delegate = self
        unitsTableView.register(UITableViewCell.self, forCellReuseIdentifier: unitsTableCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        let option = cell?.textLabel?.text
        
        if tableView.tag == 0 {
            unitsTableView.deselectRow(at: indexPath, animated: true)
//            unitsChecked[indexPath.row] = !unitsChecked[indexPath.row]
//            print(unitsChecked)
            if indexPath[1] == 1 {
                unitChecked = "metric"
            } else {
                unitChecked = "imperial"
            }
            
            unitsTableView.reloadData()
        } else {
            print("???")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView.tag == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: unitsTableCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.unitsData[indexPath.row]
            
            if indexPath[1] == 1 && self.unitChecked == "metric" {
                cell.accessoryType = .checkmark
            } else if indexPath[1] == 0 && self.unitChecked == "imperial" {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            print("!!!")
            cell = tableView.dequeueReusableCell(withIdentifier: unitsTableCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.unitsData[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.unitsData.count
        } else {
            return 0
        }
    }


}

