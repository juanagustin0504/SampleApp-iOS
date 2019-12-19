//
//  DataAccess.swift
//  gyeongnam
//
//  Created by vansa pha on 13/12/2019.
//  Copyright © 2019 Webcash. All rights reserved.
//

import Foundation

class DataAccess {
    
    private static var sharedInstance = DataAccess()
    private static var sessionConfig: URLSessionConfiguration!
    private static var session: URLSession!
    
    //Singleton configuration
    private init() {}
    
    let userAgent : String = {
        let originalUserAgent = "Mozilla/5.0 (%@; U; CPU %@ %@ like Mac OS X; ko-kr) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        let deviceInfo = DeviceInfo.info
        let infoDictionary = Bundle.main.infoDictionary
        let appIDstring: String = infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        let defaultUserAgentFormat = "%@;nma-plf=IOS;nma-plf-ver=%@;nma-app-id=%@;nma-netnm=%@;nma-model=iPhone;nma-app-ver=%@;nma-dev-id=%@;nma-phoneno=%@"
        let userAgent = String(format: defaultUserAgentFormat,
                               originalUserAgent,
                               deviceInfo.systemVersion,
                               appIDstring,
                               deviceInfo.getCarrierName(),
                               deviceInfo.getAppVersion(),
                               deviceInfo.getUUID(),
                               "")
        print("User-Agent ", userAgent, "\n")
        return userAgent
    }()
    
    static var manager: DataAccess = {
        // Timeout Configuration
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        sessionConfig.urlCache?.removeAllCachedResponses()
        session = URLSession(configuration: sessionConfig)
        return sharedInstance
    }()
    
    //MARK: ------------------------- communication data function --------------------------------
    private func getBody() -> Request {
        let body = Request()
        return body
    }
    
    func queryString<T:Encodable>(body:T) -> String {
        let request = body
        guard let str = request.asJSONString() else { return "" }
        return str
    }
    
    private func request() -> URLRequest {
        let urlSt = "https://www.bizplay.co.kr/MgGate?master_id=I_SMART_TEST_G_1"
        let methodSt = "GET"
        
        
        var request: URLRequest!
        request = URLRequest(url: URL(string: urlSt)!)
        request.httpMethod = methodSt

        
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
    
    /** Request data task with API and response data & error as completion */
    func fetch(api: String, body: Request, responseType : Response.Type, shouldShowLoading: Bool = true, completion: @escaping (Result<Response, NSError>) -> Void) {
        
        let req = request()
        
        
        DataAccess.session.dataTask(with: req) { (data, response, error) in
            
            // ❌❌❌ error -----------------------------
            if error != nil {
                completion(.failure(error! as NSError))
                return
            }
            
            // ❌❌❌ error -----------------------------
            guard let data = data else {
                completion(.failure(error! as NSError))
                return
            }
            
            guard let dataString = String(data: data, encoding: String.Encoding.utf8) else { return }
            guard let decodedDataString = dataString.removingPercentEncoding else { return }
            let replaceString = decodedDataString.replacingOccurrences(of: "+", with: " ")
            
            // ❌❌❌ error -----------------------------
            guard (self.convertToDictionary(jsonString: replaceString) != nil) else {
                completion(.failure(error! as NSError))
                return
            }
            
            // ************************** 😊😊😊 success 😊😊😊 *****************************
            print("\n\n------------------------------------------------------------------------------------------")
            print("😊\(api)😊 Successfully")
            print("JSONString ::::",replaceString)
            print("------------------------------------------------------------------------------------------\n\n")
            // ******************************************************************************
            
            guard let dataResult = replaceString.data(using: .utf8) else { return }
            do {
                let responseObj = try JSONDecoder().decode(responseType, from: dataResult)
                completion(.success(responseObj))
            } catch {
                print("error map model")
                completion(.failure(error as NSError))
                return
            }
        }.resume()
    }
    
    private func convertToDictionary(jsonString : String) -> [String:Any]? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do { return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] }
        catch {
            print("Cannon convert to Dictionary ::::> \(error.localizedDescription)")
            return nil
        }
    }
    
}
