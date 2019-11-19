//
//  WebViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/18.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import WebKit

let time = 10
var timer : Timer?
var startTimer = false


class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var temp : Int = 0

    
    
    var taskId : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view = self.webView!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lnk = "https://www.bizplay.co.kr/"
        let url = URL(string: lnk)
        let request = URLRequest(url: url!)
        
        
        webView.load(request)
        
        
        temp = time
        startTimer = true
        timer = Timer()
        timeLimitStart()
        
        let sharedApp = UIApplication.shared
        taskId = sharedApp.beginBackgroundTask(expirationHandler: {[weak self] in
            if let strongSelf = self {
                sharedApp.endBackgroundTask(strongSelf.taskId)
                strongSelf.taskId = UIBackgroundTaskIdentifier.invalid
            }
        })
        
        DispatchQueue.global().async {
            [weak self] in
            if let strongSelf = self {
                sharedApp.endBackgroundTask(strongSelf.taskId)
                strongSelf.taskId = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timeLimitStop()
    }
    
    func timeLimitStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WebViewController.timeLimit), userInfo: nil, repeats: true)
        
    }
    
    @objc func timeLimit() {
        if temp > 0 {
            temp -= 1
            
            print(temp)
        } else {
            timeLimitStop()
        }
        
        let currentState = UIApplication.shared.applicationState
        switch currentState {
        case .active:
            print("active")
        case .inactive:
            print("inactive")
        case .background:
            print("background")
            print("Remaining Time: \(UIApplication.shared.backgroundTimeRemaining)")
        @unknown default:
            print("default")
        }
    }
    
    func timeLimitStop() {
        startTimer = false
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 50, width: 100, height: 100)
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.removeFromSuperview()
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
