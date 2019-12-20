//
//  MGViewModel.swift
//  SampleApp
//
//  Created by Webcash on 2019/12/19.
//  Copyright © 2019 Moon. All rights reserved.
//

import Foundation

class MGViewModel {
    
    var responseData: Response? = nil
    
    func requestMG(completionHandler: @escaping (NSError?) -> Void) {
        let bodyReq = Request()
        DataAccess.manager.fetch(api: "mg", body: bodyReq, responseType: Response.self) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(error)
            case .success(let responseObj):
                self.responseData = responseObj
                print(responseObj)
                completionHandler(nil)
            }
        }
    }
    
}
