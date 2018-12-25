//
//  HomeViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/23/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tempUnitLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var long = ""
    var lat = ""
    
    let weatherApiClient = OpenWeatherMapClient()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentTempLabel.text = "--"
        tempUnitLabel.text = "˚F"
        self.title = "Home"
        
        self.updateView()
    }
    
    func updateView() {
        var lat = self.lat
        var long = self.long
        
        if lat == "" || long == "" {
            lat = userDefaults.object(forKey: "lat") as? String ?? ""
            long = userDefaults.object(forKey: "long") as? String ?? ""
            
            if lat == "" || long == "" {
                return
            } else {
                self.lat = lat
                self.long = long
            }
        }
        
        userDefaults.set(lat, forKey: "lat")
        userDefaults.set(long, forKey: "long")
        userDefaults.synchronize()
        
        let apiResult = weatherApiClient.makeRequest(lat: lat, long: long)
        
        let titleStr = apiResult["name"] as? String
        locationLabel.text = titleStr! // TODO: "" name...
        
        let main = apiResult["main"] as! NSDictionary
        let tempInt = Int(floor(Float("\(main["temp"].unsafelyUnwrapped)")!))
        currentTempLabel.text = String(tempInt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

