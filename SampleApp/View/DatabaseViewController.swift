//
//  NetworkingViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/20.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit

class DatabaseViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var ref : DatabaseReference! // 데이터베이스 객체 //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        // indicator 실행 //
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 50, width: 100, height: 100)
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        // 서버 통신 시작 //
//        ref = Database.database().reference()
//        
//        ref.child("version").observeSingleEvent(of: .value, with: { snapShot in
//            
//            let versionDic = snapShot.value as? Dictionary<String, Any>
//            
//            
//            let versionDbData = DbVersionData()
//            versionDbData.setValuesForKeys(versionDic!)
//            
//            if !self.checkSystemMaintenance(dbdata: versionDbData) {
//                self.checkUpdateVersion(dbdata: versionDbData)
//            }
//        })
        
        self.activityIndicator.removeFromSuperview()
        
        
    } // end of viewDidLoad
    
    func checkSystemMaintenance(dbdata:DbVersionData) -> Bool {
        if dbdata.system_maintenance {
            let refreshAlert = UIAlertController(title: "서비스 점검 알림", message: dbdata.system_maintenance_message, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action: UIAlertAction!) in
                // 앱 종료 //
                exit(0)
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        return dbdata.system_maintenance
    }
    
    // 버전 체크 //
    func checkUpdateVersion(dbdata:DbVersionData){
        let appLastestVersion = dbdata.lastest_version_code as String
        let appMinimumVersion = dbdata.minimum_version_code as String
        
        let infoDic = Bundle.main.infoDictionary!
        let appBuildVersion = infoDic["CFBundleVersion"] as? String
        
        if (Int(appBuildVersion!)! < Int(appMinimumVersion)!) {
            // 강제업데이트 //
            forceUdpateAlert(message: dbdata.force_update_message)
        } else if(Int(appBuildVersion!)! < Int(appLastestVersion)!) {
            // 선택업데이트 //
            optionalUpdateAlert(message: dbdata.optional_update_message, version: Int(dbdata.lastest_version_code)!)
        }
     } // end of checkUpdateVersion
    
    // 강제업데이트 //
    func forceUdpateAlert(message:String) {
        
        let refreshAlert = UIAlertController(title: "필수 업데이트", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action: UIAlertAction!) in
            // 앱 종료 //
            exit(0)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            // 앱 업데이트 //
            
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)

    } // end of forceUpdateAlert
    
    
    // 선택업데이트 //
    func optionalUpdateAlert(message:String, version:Int) {
        
        let refreshAlert = UIAlertController(title: "선택 업데이트", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action: UIAlertAction!) in
            // 메인화면으로 이동 //
            self.performSegue(withIdentifier: "segueMain", sender: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            // 앱 업데이트 //
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
