//
//  VIUBaseParser.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 04/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

@objcMembers class VIUBaseParser: NSObject {
    var json:JSON?
    func parseData(response:Result<Any>?){
        self.json = JSON(response!.value!)
    }
}
