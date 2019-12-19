//
//  Extension.swift
//  gyeongnam
//
//  Created by vansa pha on 13/12/2019.
//  Copyright © 2019 Webcash. All rights reserved.
//

import UIKit

//MARK: ========================= Encodable =========================
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func asJSONString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }
}

//MARK: ========================= UIViewController =========================
extension UIViewController {
    
    func alertMessage(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: action)
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    
    func alertMessageConfirm(title: String?, message: String?, confirmHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: confirmHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelHandler)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
}
