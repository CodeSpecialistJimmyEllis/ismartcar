//
//  ViewController.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import Alamofire
import UIKit
import SmartcarAuth
import SwiftyJSON

struct carData {
    var make: String = ""
    var model: String = ""
    var year: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var odometer: String = ""
}

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var vehicleText = ""
    var vehicleLocationText = ""
    var teslaCar = carData()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate.smartcar = SmartcarAuth(
            clientId: Constants.clientId,
            redirectUri: "sc\(Constants.clientId)://exchange",
            development: false,
            completion: completion
        )
        
        // display a button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        button.addTarget(self, action: #selector(self.connectPressed(_:)), for: .touchUpInside)
        button.setTitle("Connect your vehicle", for: .normal)
        button.backgroundColor = UIColor.black
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectPressed(_ sender: UIButton) {
        let smartcar = appDelegate.smartcar!
        smartcar.launchAuthFlow(viewController: self)
        
        
    }
    
    func completion(err: Error?, code: String?, state: String?) -> Any {
        // send request to exchange auth code for access token
        Alamofire.request("\(Constants.appServer)/exchange?code=\(code!)", method: .get).responseJSON {_ in
            
            // send request to retrieve the vehicle info
            
           Alamofire.request("\(Constants.appServer)/vehicle", method: .get).responseJSON { response in
                print(response.result.value!)
            
            
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    
                    let carMake = JSON.object(forKey: "make")!  as! String
                    let carModel = JSON.object(forKey: "model")!  as! String
                    let carYear = String(JSON.object(forKey: "year")!  as! Int)
                    
                    let vehicle = "\(carYear) \(carMake) \(carModel)"
                    self.vehicleText = vehicle
                    
                    self.teslaCar.make = carMake
                    self.teslaCar.model = carModel
                    self.teslaCar.year = carYear
                    
                    //self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
                }
            }
 
 
 
            
            // send request to retrive location
            
            Alamofire.request("\(Constants.appServer)/location", method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let latitude = json["data"]["latitude"].stringValue
                    let longitude = json["data"]["longitude"].stringValue
                    let locationDeclaration = "Latitude: \(latitude) and Longitude: \(longitude)"
                    self.vehicleLocationText = locationDeclaration
                    print(json["data"]["latitude"])
                    print(json["data"]["longitude"])
                    
                    self.teslaCar.latitude = latitude
                    self.teslaCar.longitude = longitude
                  /*   self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
 */
                case .failure(let error):
                    print(error)
                }
                
               
            }
            
       
            
            Alamofire.request("\(Constants.appServer)/odometer", method: .get).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let distancekm = json["data"]["distance"].stringValue
                    
               
                 
                    print(json["data"]["distance"])
                    
                    
                    self.teslaCar.odometer = distancekm
                    
                    self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
                case .failure(let error):
                    print(error)
                }
                
                
            }
                    
                   
                    
                    /*
                    print(JSON.allKeys)
                    print(JSON.allValues)
                    print(JSON.value(forKey: "data"))
                    print(JSON.object(forKey: "data"))
                    
             
                let latitude = JSON.object(forKey: "data")!
                  */
               // var locationArray = [String]()
                //    locationArray = [JSON.object(forKey: "data") as! String]
                 //   print(locationArray[1])
                 
                  //  let longitude = JSON.object(forKey: "longitude")!
                   // let year = String(JSON.object(forKey: "year")!  as! Int)
                    
                   // let vehicle = "\(locationdata)"
                   // self.vehicleText = vehicle
                    
                 //   self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
            
        
            
            
            // end request for location
        }
        
        return ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var destinationVC = segue.destination as? InfoViewController {
            destinationVC.carInfo = teslaCar
        
        }
    }

}

