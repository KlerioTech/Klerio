//
//  APIService.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 23/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import Alamofire

class APIService: NSObject {
    
    var httpClient: HTTPClientProtocol
    
    init(httpClientObj: HTTPClientProtocol) {
        self.httpClient = httpClientObj
    }
    
    func postEventDataOperation(requestBody: [String:Any], completion: @escaping (HTTPAPIResponse) -> Void) {
        let PostEventUrl = BaseUrl.shared.getUrl()
        //        let param  = getParams()
        self.httpClient.postRequest(url: PostEventUrl, params: requestBody, retryCount: 0, requestId: .KlerioPostEvent, completion: { (httpAPIResponse) in
            completion(httpAPIResponse)
        })
    }
    
    func postOriginalKlerioIdOperation(requestBody: [String:Any], completion: @escaping (HTTPAPIResponse) -> Void) {
        let PostUrl = BaseUrl.shared.getHostUrlForOriginalKlerioId()
        self.httpClient.postRequest(url: PostUrl, params: requestBody, retryCount: 0, requestId: .PostOriginalKlerioId, completion: { (httpAPIResponse) in
            completion(httpAPIResponse)
        })
    }
    
    private func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["platform"] = "iOS_App"
        return params
    }
    
}
