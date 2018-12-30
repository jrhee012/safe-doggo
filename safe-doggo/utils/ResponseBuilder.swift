//
//  ResponseBuilder.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/29/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation
import UIKit

class ResponseBuilder {
    let maxTempImp: Int = 78
    let minTempImp: Int = 68
    
    let maxTempMetr: Int = 25
    let minTempMetr: Int = 20
    
    var units: String
    var temp: String
    
    init(temp: String, units: String) {
        self.temp = temp
        self.units = units
    }
    
    private func tempCheck() -> Bool {
        let tempInt = Int((Float(self.temp)) ?? 0)
        var check = false
        
        if self.units == "metric" {
            if tempInt > minTempMetr && tempInt < maxTempMetr {
                print("aaaa")
                print(tempInt)
                check = true
            }
        } else {
            if tempInt > minTempImp && tempInt < maxTempImp {
                print("bbbb")
                print(tempInt)
                check = true
            }
        }
        
        return check
    }
    
    public func getTextResponse() -> String {
        let check = self.tempCheck()
        var textResp: String
        
        if check == true {
            textResp = "Your four-legged friend is safe and sound :)"
        } else {
            textResp = "Oh no :("
        }
        
        return textResp
    }
    
    public func getImageResponse() -> UIImage {
        let check = self.tempCheck()
        var imageResp: UIImage!
        
        if check == true {
            imageResp = UIImage(named: "bambi")
        } else {
            print("false")
            imageResp = UIImage(named: "bambi")
        }
        
        return imageResp
    }
}
