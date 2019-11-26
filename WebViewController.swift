//
//  WebViewController.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/18.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    let time = 180              // 앱 이용시간 //
    var timer : Timer?          // 타이머 객체 //
    var startTimer = false      // 타이머가 시작되었는지 검사 //
    
    var currentTime : Int = 0   // 현재 시간 //

    
    var taskId : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid // 백그라운드 동작을 위한 태스크 아이디 //
    
    var webView: WKWebView!                                                      // 웹뷰 선언 //
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()   // 인디케이터 선언 //
    
    
    
    override func loadView() {
        super.loadView()
        
        
        
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // 웹뷰 위에서 제스처 감지를 위한 설정 //
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(gotTap)
        )
        gesture.delegate = self
        self.webView?.scrollView.addGestureRecognizer(gesture)
        

        self.view = self.webView!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lnk = "https://www.bizplay.co.kr/"
        let url = URL(string: lnk)
        let request = URLRequest(url: url!)
        
        
        webView.load(request) // 웹뷰 띄우기 //
        
        
        currentTime = time
        startTimer = true
        timer = Timer()
        timeLimitStart() // 타이머 실행 //
        
        // 백그라운드, 포그라운드 감지 //
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
    }
    
    
    // 백그라운드로 갔을 때 //
    @objc func appMovedToBackground() {
        
        currentTime = time
        
        let sharedApp = UIApplication.shared
        taskId = sharedApp.beginBackgroundTask(expirationHandler: {[weak self] in
            if let strongSelf = self {
                sharedApp.endBackgroundTask(strongSelf.taskId)
                strongSelf.taskId = UIBackgroundTaskIdentifier.invalid
            }
        })
    }
    
    // 포그라운드로 갔을 때 //
    @objc func appMovedToForeground() {
        currentTime = time
    }
    
    // 뷰컨이 사라질 때 //
    override func viewWillDisappear(_ animated: Bool) {
        timeLimitStop() // 타이머 정지 //
    }
    
    // 타이머 실행 메소드 //
    func timeLimitStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WebViewController.timeLimit), userInfo: nil, repeats: true)
        
    }
    
    // 시간이 줄어드는 메소드 //
    @objc func timeLimit() {
        if currentTime > 0 {
            currentTime -= 1
            
            print(currentTime)
        } else {
            timeLimitStop()
            isScreenTimeOver = true
            self.navigationController?.popViewController(animated: true)
        }
        // 앱의 상태 체크(app status check)
//        let currentState = UIApplication.shared.applicationState
//        switch currentState {
//        case .active:
//            print("active")
//        case .inactive:
//            print("inactive")
//        case .background:
//            print("background")
//            print("Remaining Time: \(UIApplication.shared.backgroundTimeRemaining)")
//        @unknown default:
//            print("default")
//        }
    }
    
    // 타이머 정지 메소드 //
    func timeLimitStop() {
        startTimer = false
        timer?.invalidate() // 타이머 제거 //
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
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
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
    
    @objc func gotTap(gesture:UITapGestureRecognizer) {
        currentTime = time
    }

    // MARK: UIGestureRecognizerDelegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
