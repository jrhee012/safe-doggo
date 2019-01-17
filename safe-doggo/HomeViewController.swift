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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textResponseView: UITextView!
    
    var long = ""
    var lat = ""
    var currentUnits = "imperial"
    
    let weatherApiClient = OpenWeatherMapClient(units: "imperial")
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        
        //call your data populating/API calls from here
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentTempLabel.text = "--"
        
        self.getSavedUnit()
        self.updateTempUnit()
        
        self.title = "Home"
        
        self.updateView()
    }
    
    public func updateView() {
        let (lat, long) = self.getAndSaveCoordinates()
        
        if lat == "" || long == "" {
            return
        }
        
        weatherApiClient.updateUnits(units: self.currentUnits)
        let apiResult = weatherApiClient.makeRequest(lat: lat, long: long)
        
        let titleStr = apiResult["name"] as? String ?? ""
//        locationLabel.text = titleStr! // TODO: "" empty string name...
        self.setLocationLabel(location: titleStr)
        
        let main = apiResult["main"] as! NSDictionary
        let tempInt = Int(floor(Float("\(main["temp"].unsafelyUnwrapped)")!))
//        currentTempLabel.text = String(tempInt)
        self.setCurrentTempLabel(temp: tempInt)
        
        self.loadContents(temp: tempInt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setLocationLabel(location: String) {
        var text = location
        if text == "" {
            text = "Loading..."
        }
        locationLabel.text = text // TODO: "" empty string name...
    }
    
    private func setCurrentTempLabel(temp: Int) {
        currentTempLabel.text = String(temp)
    }
    
    private func getAndSaveCoordinates() -> (String, String) {
        var lat = self.lat
        var long = self.long
        
        if lat == "" || long == "" {
            lat = userDefaults.object(forKey: "lat") as? String ?? ""
            long = userDefaults.object(forKey: "long") as? String ?? ""
            
            if lat == "" || long == "" {
                return (lat, long)
            }
            
            self.lat = lat
            self.long = long
        }
        
        userDefaults.set(lat, forKey: "lat")
        userDefaults.set(long, forKey: "long")
        userDefaults.synchronize()
        
        return (lat, long)
    }
    
    private func getSavedUnit() {
        self.currentUnits = userDefaults.object(forKey: "units") as? String ?? "imperial"
    }
    
    private func updateTempUnit() {
        if self.currentUnits == "imperial" {
            tempUnitLabel.text = "˚F"
        } else {
            tempUnitLabel.text = "˚C"
        }
    }
    
    private func setTextResponseView(resp: ResponseBuilder) {
        textResponseView.text = resp.getTextResponse()
    }
    
    private func setImageView(resp: ResponseBuilder) {
        imageView.image = resp.getImageResponse()
    }
    
    private func loadContents(temp: Int) {
        let respBuilder = ResponseBuilder(temp: String(temp), units: self.currentUnits)
        
        self.setImageView(resp: respBuilder)
        self.setTextResponseView(resp: respBuilder)
    }
}

