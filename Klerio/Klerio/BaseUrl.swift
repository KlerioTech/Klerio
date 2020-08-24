//
//  BaseUrl.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import UIKit
import Alamofire

//Request IDs
enum HTTPRequestID: String {
    case KlerioPostEvent
    case PostOriginalKlerioId
    case UnKnown
    
    var name: String {
        get { return String(describing: self) }
    }
}

@objc enum HTTPStatusCode: Int {
    case Success  = 200
    case BadRequest = 400
    case Unauthorised  = 401
    case Forbidden = 403
    case NotFound  = 404
}

@objcMembers class BaseUrl: NSObject {
    
    static let shared = BaseUrl()
    
    class func sharedInstance() -> BaseUrl {
        return BaseUrl.shared
    }
    
    fileprivate var strDomainUrl: String = KlerioConstant.SERVER_HOST_URL
    fileprivate var strOriginalKlerioIdUrl: String = KlerioConstant.SERVER_HOST_GET_USERID
    private override init() {
        
    }
    
    func getDomainHost()->String{
        return self.strDomainUrl
    }
    func getOriginalKlerioIdHost()->String{
        return self.strOriginalKlerioIdUrl
    }
    
    func getUrl()->String{
        return String(format: "%@", getDomainHost())
    }
    
    func getHostUrlForOriginalKlerioId ()->String{
        return String(format: "%@", getOriginalKlerioIdHost())
    }
    
    static func getBodyParameter (params : Dictionary<String, Any>?) -> Parameters? {
        let bodyParam:Parameters? = params
        return bodyParam
    }

    static func getHeaders(isBearrerRequired:Bool = false, requestId:HTTPRequestID = .UnKnown) -> HTTPHeaders  {
        var headerValues : HTTPHeaders = [:]
        headerValues["Content-Type"] = "application/json"
//        headerValues["Accept"] = "application/json"
        headerValues["kl-client-id"] = KlerioConstant.CLIENT_ID
        headerValues["kl-client-token"] = KlerioConstant.CLIENT_TOKEN
        return headerValues
    }
    
        static func getHeadersForOriginalKlerioId(isBearrerRequired:Bool = false, requestId:HTTPRequestID = .UnKnown) -> HTTPHeaders  {
            var headerValues : HTTPHeaders = [:]
            headerValues["Content-Type"] = "application/json"
            headerValues["kl-client-id"] = KlerioConstant.CLIENT_ID
            headerValues["kl-client-token"] = KlerioConstant.CLIENT_TOKEN_GET_USERID
            return headerValues
        }
}

