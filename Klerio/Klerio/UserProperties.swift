//
//  UserProperties.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

final class UserProperties {
    static let shared = DatabaseInterface()
    static var contextProps:[String:Any] = [String:Any]()

    static func getProperties() ->[String: Any] {
        setLaunctCount()
        setAnonymousID()
        setIsIDFATrackingEnabled()
        setIdentifierForAdvertising()
        return contextProps
    }
    
    static func setIdentifierForAdvertising() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    static func setIsIDFATrackingEnabled() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id_not_allowed"] = "false"
        }else {
            contextProps["klerio_adv_id_not_allowed"] = "true"
        }
    }
    
    static func setAnonymousID() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_anonymous_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }else{
            contextProps["klerio_anonymous_id"] = UIDevice.current.identifierForVendor!.uuidString
        }
    }
    
    static func setLaunctCount() {
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        contextProps["klerio_launch_count"] = currentCount
    }
    
}
