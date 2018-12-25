//
//  LocationViewController.swift
//  safe-doggo
//
//  Created by Jaehyuk Rhee on 12/24/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBAction func updateButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Location"
    }
    
    
}
