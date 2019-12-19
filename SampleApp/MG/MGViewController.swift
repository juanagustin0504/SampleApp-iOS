//
//  MGViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/12/19.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit

class MGViewController: UIViewController {

    let mgViewModel = MGViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestMG()
    }

    private func requestMG() {
        mgViewModel.requestMG { (error) in
            if error == nil {
                self.gotoLoginScreen()
            } else {
                self.alertMessage(title: "안내", message: error?.localizedDescription, action: nil)
            }
        }
    }
    
    private func gotoLoginScreen() {
        DispatchQueue.main.async {
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let introVc = mainSb.instantiateViewController(withIdentifier: "TestViewController_sid")
            self.navigationController?.pushViewController(introVc, animated: true)
        }
    }

}
