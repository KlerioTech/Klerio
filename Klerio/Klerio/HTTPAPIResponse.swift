//
//  HTTPAPIResponse.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import UIKit

class HTTPAPIResponse: NSObject {
    var responseData : Data?
    var status : HTTPAPIStatus
    
    init(responseData:Data?, status:HTTPAPIStatus) {
        self.responseData = responseData
        self.status = status
    }
    
    func getDictionaryObject() -> Dictionary<String, Any>? {
        if let respData = self.responseData {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: respData, options:JSONSerialization.ReadingOptions(rawValue: 0))
                guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                    print("Not a Dictionary")
                    return nil
                }
                return dictionary
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
}
