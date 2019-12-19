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
        let C_PROGRAM_VER       : String
        let C_MINIMUM_VER       : String
        let C_ACT_YN            : String
        let C_ACT_ERR_MSG       : String
        let C_UPDATE_CLOSE_YN   : String
        let C_UPDATE_ACT        : String
    }
}
