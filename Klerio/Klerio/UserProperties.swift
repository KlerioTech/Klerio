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
    static let shared = UserProperties()
    var contextProps:[String:Any] = [String:Any]()

    func getUserProperty(clientProperties: [String:Any]?) -> [String: Any] {
        let  userProperties = self.getProperties()
        if (clientProperties != nil) {
            var mergedProperties = clientProperties!
            mergedProperties.merge(userProperties) { (v1, v2) -> Any in
                return v1
            }
            DatabaseInterface.shared.saveUserProperty(userProp: mergedProperties)
        }else{
            DatabaseInterface.shared.saveUserProperty(userProp: userProperties)
        }
        
        if let userPropertyDB = DatabaseInterface.shared.getUserProperty() {
            return userPropertyDB
        }else{
            return userProperties
        }
    }
    
    func getProperties() ->[String: Any] {
        if let userPropertyDB = DatabaseInterface.shared.getUserProperty() {
            contextProps = userPropertyDB
        }
        setLaunctCount()
        setAnonymousID()
        setIsIDFATrackingEnabled()
        setIdentifierForAdvertising()
        return contextProps
    }
    
    func setIdentifierForAdvertising() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    func setIsIDFATrackingEnabled() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id_not_allowed"] = "false"
        }else {
            contextProps["klerio_adv_id_not_allowed"] = "true"
        }
    }
    
    func setAnonymousID() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_anonymous_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }else{
            contextProps["klerio_anonymous_id"] = UIDevice.current.identifierForVendor!.uuidString
        }
    }
    
    func setLaunctCount() {
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        contextProps["klerio_launch_count"] = currentCount
    }
    
}
