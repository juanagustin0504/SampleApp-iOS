//
//  NetworkingViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/20.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NetworkingViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
        
        let ref = Database.database().reference()
        
        ref.child("init/init_data/").observeSingleEvent(of: .value) {
            (snapshot) in
            let initData = snapshot.value as? [String : String]
            
            self.activityIndicator.removeFromSuperview()
            
//            print(initData!)
            
            if let maintainance = initData!["maintainance"] {
                if maintainance.elementsEqual("true") {
                    // 서비스 점검 중일 때 //
                    let alert = UIAlertController(title: nil, message: "서비스 점검 중입니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .cancel, handler: {
                        (action) in exit(0)
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            
            if let requiredUpdate = initData!["required_update"] {
                if requiredUpdate.elementsEqual("true") {
                    // 앱 업데이트 후 이용해야 할 때 //
                    let alert = UIAlertController(title: nil, message: "앱 업데이트 후 이용해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .cancel, handler: {
                        (action) in exit(0)
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            
            if let selectUpdate = initData!["select_update"] {
                if selectUpdate.elementsEqual("true") {
                    // 앱 업데이트 선택할 때 //
                    let alert = UIAlertController(title: nil, message: "앱 업데이트 후 이용하시겠습니까?", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "확인", style: .cancel, handler: {
                        (action) in exit(0)
                    })
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
        }
        
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
