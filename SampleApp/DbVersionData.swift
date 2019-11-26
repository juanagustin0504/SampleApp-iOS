//
//  DbVersionData.swift
//  SampleApp
//
//  Created by Webcash on 2019/11/25.
//  Copyright © 2019 Moon. All rights reserved.
//

import UIKit

@objcMembers
class DbVersionData: NSObject {
    var system_maintenance  : Bool          // 서비스 점검 중 //
    var system_maintenance_message : String // 서비스 점검 중 메세지 //
    var lastest_version_code: String        // 최신버전 코드 //
    var lastest_version_name: String        // 최신버전 명 //
    var minimum_version_code: String        // 최소버전 코드 //
    var minimum_version_name: String        // 최소버전 명 //
    var force_update_message: String        // 강제업데이트 메세지 //
    var optional_update_message: String     // 선택업데이트 메세지 //
    
    
    init(system_maintenance:Bool, system_maintenance_message:String,
         lastest_version_code:String, lastest_version_name:String,
         minimum_version_code:String, minimum_version_name:String,
         force_update_message:String, optional_update_message:String) {
        
        self.system_maintenance = system_maintenance
        self.system_maintenance_message = system_maintenance_message
        self.lastest_version_code = lastest_version_code
        self.lastest_version_name = lastest_version_name
        self.minimum_version_code = minimum_version_code
        self.minimum_version_name = minimum_version_name
        self.force_update_message = force_update_message
        self.optional_update_message = optional_update_message
    }
    
    convenience override init() {
        self.init(system_maintenance: false, system_maintenance_message: "",
                  lastest_version_code: "", lastest_version_name: "",
                  minimum_version_code: "", minimum_version_name: "",
                  force_update_message: "", optional_update_message: ""
        )
    }

}
