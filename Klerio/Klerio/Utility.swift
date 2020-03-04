//
//  Utility.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 25/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

extension NSObject {
    
    static func getStringFromClass(aClassName: AnyClass) -> String{
        return String(describing: aClassName)
    }
    
    static func generateError(title:String,code:Int, message:String) -> NSError{
        let error = NSError(domain: title, code: code, userInfo: [NSLocalizedDescriptionKey: message])
        return error
    }
    
    static func dicToString(dict:NSDictionary) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) {
            if let json = String(bytes: data, encoding: .utf8) {
                return json
            }
        }
        return ""
    }
    
//    static func stringToDic(string:String) -> NSDictionary {
//        if  let data = string.data(using: .utf8),
//            let jsonArray = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? NSDictionary {
//            return jsonArray
//        }
//        return NSDictionary()
//    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
