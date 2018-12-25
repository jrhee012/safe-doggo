//
//  LocationViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/24/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    @IBOutlet weak var locationSettingTabelView: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    
    var long: String!
    var lat: String!
    var locationManager = CLLocationManager()
    let CellIdentifier = "LocationSettingTableCellView"
    let data = ["Use device location", "Search"]
    var checked: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Location"
        //        locationSettingTabelView.dataSource = self
        checked = [Bool](repeating: false, count: self.data.count)
        locationSettingTabelView.dataSource = self
        locationSettingTabelView.delegate = self
        locationSettingTabelView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        searchBarView.isUserInteractionEnabled = false
        searchBarView.alpha = 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let option = cell?.textLabel?.text as! String
        
        if option == "Search" {
            // search bar
            searchBarView.isUserInteractionEnabled = true
            searchBarView.alpha = 1.0
            searchBarView.delegate = self
        } else {
            // search bar
            searchBarView.isUserInteractionEnabled = false
            searchBarView.alpha = 0.5
            
            // device location
            locationManager.delegate = self
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    @IBAction func updateButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let lat = String(userLocation.coordinate.latitude)
        let long = String(userLocation.coordinate.longitude)
        
        self.lat = lat
        self.long = long
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("1")
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("2")
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("@")
        print(searchBar.text)
    }
}
