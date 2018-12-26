//
//  ApiClient.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/24/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

class ApiClient {
    public func syncRequest(request: NSMutableURLRequest) -> NSDictionary {
        let semaphore = DispatchSemaphore(value: 0)
        var result:NSDictionary = [:]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                result = json
                semaphore.signal()
            } catch let error as NSError {
                print(error)
            }
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
    
    public func asyncRequest(request: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

enum Units {
    case metric
    case imperial
    
    init(value: String) {
        switch value {
        case "metric": self = .metric
        case "imperial": self = .imperial
        default: self = .imperial
        }
    }
}

class OpenWeatherMapClient: ApiClient {
    let apiKey: String = "6f31a9738232e5edd96eb2bbc1edd406"
    var units = "imperial"
    
    init(units: String) {
        if Units(value: units) == .metric {
            self.units = "metric"
        } else {
            self.units = "imperial"
        }
    }
    
    private func createURLWithString(lat: String, long: String) -> NSURL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&APPID=\(self.apiKey)&units=\(units)"
        return NSURL(string: urlString)
    }
    
    public func makeRequest(lat: String, long: String) -> NSDictionary {
        let url = self.createURLWithString(lat: lat, long: long)
        let request = NSMutableURLRequest(url: url! as URL);
        request.httpMethod = "GET"
        let results = super.syncRequest(request: request)
//        print(results)
        return results
    }
    
    public func updateUnits(units: String) {
        self.units = units
    }
}

class OpenStreetMapClient: ApiClient {
    let baseUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
    
    public func makeRequest(city: String) -> [NSDictionary] {
        let inputString = city
        let stringToArray = inputString.components(separatedBy: " ")
        let stringFromArray = stringToArray.joined(separator: "%20")
        let url = NSURL(string: "\(baseUrl)\(stringFromArray)")
        let request = NSMutableURLRequest(url: url! as URL);
        request.httpMethod = "GET"
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: [NSDictionary] = []
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            guard let data = data, error == nil else { return }
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [NSDictionary]
                result = json
                semaphore.signal()
            } catch let error as NSError {
                print(error)
            }
        }
        
        task.resume()
        semaphore.wait()
    
        return result
    }
}
