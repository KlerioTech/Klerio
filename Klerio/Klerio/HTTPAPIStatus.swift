//
//  HTTPAPIStatus.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import UIKit

class HTTPAPIStatus : NSObject {
    
    var statusCode : Int = 0
    var isSuccess : Bool = false
    var errorLocalizedDescription : String?
    var isFromCache = false
    
    init(statusCode:Int, isSucess:Bool, description:String?) {
        self.statusCode = statusCode
        self.isSuccess = isSucess
        self.errorLocalizedDescription = description
    }
}
