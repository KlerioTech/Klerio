//
//  HTTPBaseModel.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import UIKit

@objcMembers class HTTPBaseModel: NSObject {
    
    var statusCode : Int = 0
    var isSuccess : Bool = false
    var errorLocalizedDescription : String?
    var isFromCache : Bool = false
    
    var name: String {
        get { return String(describing: self) }
    }
    
    func setAPIResponseObject(httpAPIResponse:HTTPAPIResponse) {
        self.statusCode = httpAPIResponse.status.statusCode
        self.isSuccess = httpAPIResponse.status.isSuccess
        self.isFromCache = httpAPIResponse.status.isFromCache
        self.errorLocalizedDescription = httpAPIResponse.status.errorLocalizedDescription
    }
}

