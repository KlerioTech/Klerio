//
//  HTTPStatusHandler.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Alamofire

class HTTPStatusHandler: NSObject {
    
    enum StatusCode:Int {
        case none
    }
    
    enum NetworkErrorCode:Int {
        case networkNotAvailable
        case none
    }
    
    static func getAPIStatus(error:AFError?, isSucess:Bool) -> HTTPAPIStatus {
        return HTTPAPIStatus(statusCode: (error?._code)!, isSucess: isSucess, description: error?.localizedDescription)
    }
    
    static func getLocalizedMessageForAPIStatus(apiStatus:HTTPAPIStatus) -> String? {
        return apiStatus.errorLocalizedDescription
    }
}
