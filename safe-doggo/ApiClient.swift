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
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    result = convertedJsonIntoDict
                    semaphore.signal()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
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

class OpenWeatherMapClient: ApiClient {
    let apiKey: String = "6f31a9738232e5edd96eb2bbc1edd406"
    
    private func createURLWithString(lat: String, long: String) -> NSURL? {
        let urlString = "api.openweathermap.org/data/2.5/weather?lat=\(lat)&long=\(long)&APPID=\(self.apiKey)"
        return NSURL(string: urlString)
    }
    
    public func makeRequest(lat: String, long: String) {
        let url = self.createURLWithString(lat: lat, long: long)
        let request = NSMutableURLRequest(url:url! as URL);
        request.httpMethod = "GET"
        let results = super.syncRequest(request: request)
        print(results)
    }
}
