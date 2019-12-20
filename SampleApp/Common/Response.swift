//
//  Response.swift
//  SampleApp
//
//  Created by Webcash on 2019/12/19.
//  Copyright © 2019 Moon. All rights reserved.
//

import Foundation

struct Response: Decodable {
    
    let RESP_DATA: _resp_data
    
    struct _resp_data: Decodable {
        let C_PROGRAM_VER       : String    // 현재 프로그램 버전 //
        let C_MINIMUM_VER       : String    // App서비스 사용가능 최소버전 //
        let C_ACT_YN            : String    // 서비스 가능 여부 //
        let C_ACT_ERR_MSG       : String    // 서비스불가 대응내용 / 공지내용 //
        let C_UPDATE_CLOSE_YN   : String    // 강제 업데이트 여부 //
        let C_UPDATE_ACT        : String    // 업데이트 Message //
    }
}
