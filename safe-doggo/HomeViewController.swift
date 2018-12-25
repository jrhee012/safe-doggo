//
//  HomeViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/23/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit
//import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tempUnitLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var long = ""
    var lat = ""
    
//    var locationManager = CLLocationManager()
    let weatherApiClient = OpenWeatherMapClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentTempLabel.text = "--"
        tempUnitLabel.text = "˚F"
        self.title = "Home"
        
        self.updateView()
//        let nav = self.navigationController?.navigationBar
//        nav?.tintColor = UIColor.white
//        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

//        locationManager.delegate = self
        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
//
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
    }
    
    func updateView() {
        let lat = self.lat
        let long = self.long
        print(self.lat, self.long)
        print("1")
        print(lat, long)
        if lat == "" || long == "" {
            return
        }
        print("2")
        let apiResult = weatherApiClient.makeRequest(lat: lat, long: long)
        
        let titleStr = apiResult["name"] as? String
        
        //        print(apiResult)
        
        // update
        //        locationLabel.text = titleStr!
        locationLabel.text = titleStr!
        let main = apiResult["main"] as! NSDictionary
        let tempInt = Int(floor(Float("\(main["temp"].unsafelyUnwrapped)")!))
        print(tempInt)
        currentTempLabel.text = String(tempInt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//
//        let lat = String(userLocation.coordinate.latitude)
//        let long = String(userLocation.coordinate.longitude)
//
//        let apiResult = weatherApiClient.makeRequest(lat: lat, long: long)
//
//        let titleStr = apiResult["name"] as? String
//
////        print(apiResult)
//
//        // update
////        locationLabel.text = titleStr!
//        self.title = titleStr!
//
//        let main = apiResult["main"] as! NSDictionary
////        currentTempLabel.text = "\(main["temp"].unsafelyUnwrapped)"
//
//        let tempInt = Int(floor(Float("\(main["temp"].unsafelyUnwrapped)")!))
//        print(tempInt)
//        currentTempLabel.text = String(tempInt)
//    }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        if ((error) != nil) {
//            print(error)
//        }
//    }
}

