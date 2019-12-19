//
//  DeviceInfo.swift
//  ZeroPay
//
//  Created by iMac007 on 13/08/2019.
//  Copyright © 2019 Webcash. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

class DeviceInfo {
    
    enum ScreenSizeType {
        case Mini
        case Meduim
        case Plus
        case XSerial
    }
    
    //single config
    private init() {}
    static let info = DeviceInfo()
    
    var model: String { return UIDevice.current.model }
    var systemName: String { return UIDevice.current.systemName }
    var systemVersion: String { return UIDevice.current.systemVersion }
    
    func deviceId() -> Int {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960: return 0 //iPhone 4/4s
            case 1136:  return 1 //iPhone 5 or 5S or 5C
            case 1334: return 2 //iPhone 6/6S/7/8
            case 1920, 2208: return 3 //iPhone 6+/6S+/7+/8+
            case 2436: return 4 //iPhone X, XS
            case 2688: return 5 //iPhone XS Max
            case 1792: return 6 //iPhone XR
            default: return 999 //otherwise
            }
        }
        return 0
    }
    
    func deviceSize() -> CGSize { return UIScreen.main.bounds.size }
    
    func groupDeviceScreenType() -> ScreenSizeType {
        let _deviceId = deviceId()
        if _deviceId == 0 || _deviceId == 1 { return .Mini}
        else if _deviceId == 2 { return .Meduim }
        else if _deviceId == 3 { return .Plus }
        else if _deviceId == 4 || _deviceId == 5 || _deviceId == 6 { return .XSerial }
        else { return .Meduim }
    }
    
    func getAppVersion() -> String {
        let mainBundleDictionary = Bundle.main.infoDictionary! as NSDictionary
        return mainBundleDictionary.object(forKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    func getUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func getCarrierName() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        return networkInfo.subscriberCellularProvider?.carrierName ?? ""
    }
    
}

