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
        
    }

    private func requestMG() {
        mgViewModel.requestMG { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.checkSystemMaintenance(responseObj: self.mgViewModel.responseData!)
                    self.checkUpdateVersion(responseObj: self.mgViewModel.responseData!)
                    self.activityIndicator.removeFromSuperview()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.alertMessage(title: "안내", message: error?.localizedDescription, action: nil)
                }
                
            }
        }
    }
    
    private func gotoMainScreen() {
        DispatchQueue.main.async {
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let mainVc = mainSb.instantiateViewController(withIdentifier: "MainViewController_sid")
            self.navigationController?.pushViewController(mainVc, animated: true)
        }
    }
    
    func checkSystemMaintenance(responseObj: Response) {
        if responseObj.RESP_DATA.C_ACT_YN == "N" {
            self.alertMessage(title: "서비스 점검 알림", message: responseObj.RESP_DATA.C_ACT_ERR_MSG, action: { action in exit(0) })
        }
    }
    
    // 버전 체크 //
    func checkUpdateVersion(responseObj: Response) {
        let appLastestVersion = responseObj.RESP_DATA.C_PROGRAM_VER
        let appMinimumVersion = responseObj.RESP_DATA.C_MINIMUM_VER
        
        let infoDic = Bundle.main.infoDictionary!
        let appBuildVersion = infoDic["CFBundleVersion"] as? String
        
        if (appBuildVersion! < appMinimumVersion) {
            // 강제업데이트 //
            forceUdpateAlert(message: responseObj.RESP_DATA.C_UPDATE_ACT)
        } else if (appBuildVersion! < appLastestVersion) {
            // 선택업데이트 //
            optionalUpdateAlert(message: responseObj.RESP_DATA.C_UPDATE_ACT, version: Int(appLastestVersion)!)
        }
     } // end of checkUpdateVersion
    
    // 강제업데이트 //
    func forceUdpateAlert(message:String) {
        
        self.alertMessageConfirm(title: "필수 업데이트", message: message, confirmHandler: {(action) in
            UIApplication.shared.open(URL(string: "itunes://")!, options: [:], completionHandler: nil)
        }, cancelHandler: {(action) in
            exit(0)
        })

    } // end of forceUpdateAlert
    
    
    // 선택업데이트 //
    func optionalUpdateAlert(message:String, version:Int) {
        
        self.alertMessageConfirm(title: "선택 업데이트", message: message, confirmHandler: {(action) in
            UIApplication.shared.open(URL(string: "itunes://")!, options: [:], completionHandler: nil)
        }, cancelHandler: {(action) in
            self.gotoMainScreen()
        })
        
    } // end of optionalUpdateAlert

}
