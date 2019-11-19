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
    
    var time = 180
    var timer = Timer()
    var startTimer = false
    
    @IBOutlet var lblTimer: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !startTimer {
            startTimer = true
            timeLimitStart()
        }
        
        
    }
    
    func timeLimitStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeLimit), userInfo: nil, repeats: true)
    }
    
    @objc func timeLimit() {
        if time > 0 {
            time -= 1
            lblTimer.text = "\(time / 60)분 \(time % 60)초"
        } else {
            timeLimitStop()
        }
    }
    
    func timeLimitStop() {
        startTimer = false
        timer.invalidate()
    }
    
    @IBAction func btnGetLocalLocation(_ sender: UIButton) {
        
        locationManager.requestWhenInUseAuthorization()
        
        locationCheck()
        
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
    
    @objc func locationCheck(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alert = UIAlertController(title: "위치권한 설정이 '허용 안 함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                self.locLast = nil
            }
            alert.addAction(logNoAction)
            alert.addAction(logOkAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
