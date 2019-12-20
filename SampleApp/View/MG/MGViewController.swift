//
//  MGViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/12/19.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit

class MGViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    let mgViewModel = MGViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        activityIndicator.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 50, width: 100, height: 100)
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        self.requestMG()
        self.activityIndicator.removeFromSuperview()
    }

    private func requestMG() {
        mgViewModel.requestMG { (error) in
            if error == nil {
                
            } else {
                self.alertMessage(title: "안내", message: error?.localizedDescription, action: nil)
            }
        }
    }
    
    private func gotoLoginScreen() {
        
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        let mainVc = mainSb.instantiateViewController(withIdentifier: "MainViewController_sid")
        self.navigationController?.pushViewController(mainVc, animated: true)
        
    }
    
    func checkSystemMaintenance(responseObj: Response) {
        if responseObj.RESP_DATA.C_ACT_YN == "N" {
            let refreshAlert = UIAlertController(title: "서비스 점검 알림", message: responseObj.RESP_DATA.C_ACT_ERR_MSG, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action: UIAlertAction!) in
                // 앱 종료 //
                exit(0)
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    // 버전 체크 //
    func checkUpdateVersion(responseObj: Response) {
        let appLastestVersion = responseObj.RESP_DATA.C_PROGRAM_VER
        let appMinimumVersion = responseObj.RESP_DATA.C_MINIMUM_VER
        
        let infoDic = Bundle.main.infoDictionary!
        let appBuildVersion = infoDic["CFBundleVersion"] as? String
        
        if (Int(appBuildVersion!)! < Int(appMinimumVersion)!) {
            // 강제업데이트 //
            forceUdpateAlert(message: responseObj.RESP_DATA.C_UPDATE_ACT)
        } else if(Int(appBuildVersion!)! < Int(appLastestVersion)!) {
            // 선택업데이트 //
            optionalUpdateAlert(message: responseObj.RESP_DATA.C_UPDATE_ACT, version: Int(appLastestVersion)!)
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
            self.gotoLoginScreen()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            // 앱 업데이트 //
            
            
        }))
        
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    } // end of optionalUpdateAlert

}
