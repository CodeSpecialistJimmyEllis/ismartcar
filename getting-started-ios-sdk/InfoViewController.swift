//
//  InfoViewController.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import UIKit
import Alamofire
import SmartcarAuth
import SwiftyJSON
import MapKit

class InfoViewController: UIViewController {
    
    var text = ""
    var carInfo = carData()

    
    @IBOutlet weak var carMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
      
        // display the vehicle info
        let vehicleInfo = UILabel(frame: CGRect(x: 5, y: 100, width: 1000, height: 200))
        vehicleInfo.text = "Make: \(carInfo.make) \(carInfo.model) Year: \(carInfo.year) Latitude: \(carInfo.latitude) Longitude: \(carInfo.longitude) Odometer(Km): \(carInfo.odometer)"
        self.view.addSubview(vehicleInfo)
        
       
        
      
    }
    
 
    
    @IBAction func unlockCar(_ sender: Any) {
        
        Alamofire.request("\(Constants.appServer)/unlock", method: .get).responseJSON { response in
       
              // print(response.result.value!)
            }
    }
    
    @IBAction func lockCar(_ sender: Any) {
        
        
        Alamofire.request("\(Constants.appServer)/lock", method: .get).responseJSON { response in
            
            // print(response.result.value!)
        }
    }
    
    
}

