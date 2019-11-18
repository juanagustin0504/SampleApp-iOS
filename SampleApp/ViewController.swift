//
//  ViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/18.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var locLast : CLLocationCoordinate2D?
    var getLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnGetLocalLocation(_ sender: UIButton) {
        
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if getLocation {
                let alert = UIAlertController(title: "위치", message: "위도 : \((locLast?.latitude)!)\n경도 : \((locLast?.longitude)!)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocationCoordinate2D = manager.location!.coordinate
        
        locLast = locValue
        
        let alert = UIAlertController(title: "위치", message: "위도 : \(locValue.latitude)\n경도 : \(locValue.longitude)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        getLocation = true
    }
    
    
}
