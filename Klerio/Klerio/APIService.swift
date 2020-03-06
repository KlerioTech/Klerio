//
//  APIService.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 23/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import Alamofire

//protocol APIService {
//    func send(events: [EventModel])
//}
//
//final class KlerioAPIClient: APIService {
//
//    func send(events: [EventModel]) {
//        //TODO: implement this
//
//        //if success
//        DatabaseInterface.shared.remove(eventWithIds: events.map { $0.id })
//    }
//}


class APIService: NSObject {
    
    var httpClient: HTTPClientProtocol
    
    init(httpClientObj: HTTPClientProtocol) {
        self.httpClient = httpClientObj
    }
    
    func postEventDataOperation(requestBody: [String:Any], completion: @escaping (HTTPAPIResponse) -> Void) {
        let PostEventUrl = BaseUrl.shared.getUrl()
        let param  = getParams()
        self.httpClient.postRequest(url: PostEventUrl, params: param, retryCount: 0, requestId: .KlerioPostEvent, completion: { (httpAPIResponse) in
            completion(httpAPIResponse)
        })
    }
    
    private func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["platform"] = "iOS_App"
        return params
    }
    
}
