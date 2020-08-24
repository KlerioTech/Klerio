//
//  Constant.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 25/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

class KlerioConstant: NSObject   {
    static let DEFAULT_CONNECT_TIMEOUT_MS = 15000
    static let DEFAULT_READ_TIMEOUT_MS = 15000
    static let SERVER_HOST_URL = "https://ingester.klerio.xyz/ingester"
    static let CLIENT_ID = "39875b2f-3221-4b9c-b591-e492e519a2b9"
    static let CLIENT_TOKEN = "c+w6jJN8Wdn8T63RhjQTZQ=="
    static let BATCH_SIZE = 12 // BATCH_SIZE_ONLINE = BATCH_SIZE_OFFLINE
    static let SERVER_HOST_GET_USERID = "http://ingester.klerio.xyz/getOriginalKlerioId"
    static let CLIENT_TOKEN_GET_USERID = "rIK8x7j2KflCrkTbByQTjQ=="

}

