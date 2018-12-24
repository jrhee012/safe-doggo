//
//  HomeViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/23/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    var long: String!
    var lat: String!
    
    var locationManager = CLLocationManager()
    let weatherApiClient = OpenWeatherMapClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
//        self.long = String(userLocation.coordinate.longitude)
//        self.lat = String(userLocation.coordinate.latitude)
        
        var lat = String(userLocation.coordinate.latitude)
//        lat = String(lat[lat.startIndex...lat.index(lat.startIndex, offsetBy: 4)])
        
        var long = String(userLocation.coordinate.longitude)
//        long = String(long[long.startIndex...long.index(long.startIndex, offsetBy: 4)])
        
        weatherApiClient.makeRequest(lat: lat, long: long)
//        print(self.long, self.lat)
    }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        if ((error) != nil) {
//            print(error)
//        }
//    }
}

