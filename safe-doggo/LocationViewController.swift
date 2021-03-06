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
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var long: String!
    var lat: String!
    var locationManager = CLLocationManager()
    let CellIdentifier = "LocationSettingTableCellView"
    let SearchCellIdentifier = "SearchTableCellView"
    let data = ["Use device location", "Search"]
    var searchResult: [String] = []
    var searchMap: NSMutableDictionary = [:]
    var checked: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Location"
        
        locationSettingTabelView.tag = 0
        searchResultTableView.tag = 1
        
        checked = [Bool](repeating: false, count: self.data.count)
        
        locationSettingTabelView.dataSource = self
        locationSettingTabelView.delegate = self
        locationSettingTabelView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchCellIdentifier)
        
        searchBarView.isUserInteractionEnabled = false
        searchBarView.alpha = 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let option = cell?.textLabel?.text
        
        if tableView.tag == 0 {
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
        } else if tableView.tag == 1 {
            var result: NSDictionary = [:]
            
            for (key, value) in searchMap as! [String: NSDictionary] {
                if key == option {
                    result = value
                }
            }
            
            self.lat = result["lat"] as? String
            self.long = result["lon"] as? String
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView.tag == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            cell.textLabel?.text = self.data[indexPath.row]
        } else if tableView.tag == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: SearchCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.searchResult[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: SearchCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.data[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.data.count
        } else if tableView.tag == 1 {
            return self.searchResult.count
        } else {
            return self.data.count
        }
    }
    
    
    @IBAction func updateButtonAction(_ sender: Any) {
        let root = navigationController?.viewControllers[0] as! HomeViewController
        
        root.long = self.long as String
        root.lat = self.lat as String
        root.updateView()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
//
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.lat = String(userLocation.coordinate.latitude)
        self.long = String(userLocation.coordinate.longitude)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let apiClient = OpenStreetMapClient()
        let results = apiClient.makeRequest(city: searchBar.text!)
        
        searchResult = []
        for result in results {
            let name = result["display_name"] as! String
            print(name)
            searchResult.append(name)
            searchMap[name] = result
        }
        
        searchResultTableView.reloadData()
    }
}
