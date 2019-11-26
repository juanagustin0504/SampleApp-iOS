//
//  ViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/18.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import CoreLocation

var isScreenTimeOver = false // 앱 미사용 시간 검사 변수 //

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager() // Location 사용을 위한 매니저 선언 //
    
    var locLast : CLLocationCoordinate2D?     // Location의 마지막 위치를 담을 변수 //
    var getLocation = false                   // 마지막 Location의 위치를 받아왔는지 검사하는 변수 //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbVC = self.storyboard?.instantiateViewController(withIdentifier: "checkDatabase")
        self.present(dbVC!, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isScreenTimeOver { // 앱 미사용으로 인해 메인뷰로 돌아왔을 때 //
            showAlert()
            isScreenTimeOver = !isScreenTimeOver
//            print("\(isScreenTimeOver)")
        }
    }
    
    
    // 앱 미사용 알림 알렛 //
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "일정시간 앱을 이용하지 않아 메인화면으로 이동합니다.", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true)
    }
    
    // 현재 위치정보 가져오는 버튼 //
    @IBAction func btnGetLocalLocation(_ sender: UIButton) {
        
        
        // 위치 권한 요청 //
        locationManager.requestWhenInUseAuthorization()
        
        
        // 위치 권한 요청 검사 //
        locationCheck()
        
        
        if CLLocationManager.locationServicesEnabled() { // 위치 서비스 접근 가능 //
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation() // 위치 업데이트 //
            
            // 위치정보를 갱신하였을 때 //
            if getLocation {
                let alert = UIAlertController(title: "위치", message: "위도 : \((locLast?.latitude)!)\n경도 : \((locLast?.longitude)!)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // 위치가 업데이트 될 때 호출되는 메소드 //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocationCoordinate2D = manager.location!.coordinate
        
        locLast = locValue // 마지막 위치 저장 //
        
        let alert = UIAlertController(title: "위치", message: "위도 : \(locValue.latitude)\n경도 : \(locValue.longitude)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        getLocation = true
    }
    
    // 위치 권한 검사 //
    @objc func locationCheck(){
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alert = UIAlertController(title: "위치권한 설정이 '허용 안 함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in // 위치 권한 설정을 위한 설정창 열기 //
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
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
