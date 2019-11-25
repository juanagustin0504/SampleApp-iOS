//
//  NetworkingViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/20.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import Firebase

class NetworkingViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        // indicator 실행 //
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 50, width: 100, height: 100)
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        // 서버 통신 시작 //
        
        
        ref = Database.database().reference()
        
        ref.child("version").observeSingleEvent(of: .value, with: { snapShot in
            let versionDic = snapShot.value as? Dictionary<String, AnyObject>
            
            let versionDbData = DbVersionData()
            versionDbData.setValuesForKeys(versionDic!)
           
            print("[force_update_message] : \(versionDbData.force_update_message)")
            print("[lastest_version_code] : \(versionDbData.lastest_version_code)")
            print("[minimum_version_name] : \(versionDbData.minimum_version_name)")
            print("[optional_update_message] : \(versionDbData.optional_update_message)")
        
        })
        
        self.activityIndicator.removeFromSuperview()
        
        
    } // end of viewDidLoad
    
    // 버전 체크 //
    func checkUpdateVersion(dbdata:DbVersionData){
        let appLastestVersion = dbdata.lastest_version_code as String
        let appMinimumVersion = dbdata.minimum_version_code as String
        
        let infoDic = Bundle.main.infoDictionary!
        let appBuildVersion = infoDic["CFBundleVersion"] as? String
        
        if (Int(appBuildVersion!)! < Int(appMinimumVersion)!) {
            // 강제업데이트 //
            forceUdpateAlert(message: dbdata.force_update_message)
        }else if(Int(appBuildVersion!)! < Int(appLastestVersion)!) {
            // 선택업데이트 //
            optionalUpdateAlert(message: dbdata.optional_update_message, version: Int(dbdata.lastest_version_code)!)
        }
     } // end of checkUpdateVersion
    
    // 강제업데이트 //
    func forceUdpateAlert(message:String) {
        
        let refreshAlert = UIAlertController(title: "UPDATE", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Go to AppStore")
            // AppStore 로 가도록 연결시켜 주면 됩니다.
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)

    } // end of forceUpdateAlert
    
    
    // 선택업데이트 //
    func optionalUpdateAlert(message:String, version:Int) {
        
        let refreshAlert = UIAlertController(title: "UPDATE", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
            print("Go to AppStore")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Close Alert")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    } // end of optionalUpdateAlert
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
