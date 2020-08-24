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
    private var apiService: APIService = APIService(httpClientObj: HTTPClient.shared)

    func setKlerioUserID(userId: String) {
        var UserDict: [String:Any] = [String:Any]()
        UserDict["userId"] = userId
        let  userProperties = self.getProperties()
        //TODO: make MD5
        UserDict["klerioAnonymousId"] = userProperties["klerio_anonymous_id"]

        var dict: [String:Any] = [String:Any]()
        dict["id"] = userId

        apiService.postOriginalKlerioIdOperation(requestBody: UserDict) {(httpAPIResponse) in
            if httpAPIResponse.status.statusCode == HTTPStatusCode.Success.rawValue {
                print("OriginalKlerioId :: ",httpAPIResponse.description)
                dict["klerio_anonymous_id"] = "123"
            }else{
                print("getOriginalKlerioIdAPIFails")
            }
        }
        _ = self.getUserProperty(clientProperties: dict)
    }
    
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
//        setUserID()
        setIsIDFATrackingEnabled()
        setIdentifierForAdvertising()
        return contextProps
    }
    
    func setIdentifierForAdvertising() {
        //ToDo: remove later
        contextProps["klerio_adv_id"] = UIDevice.current.identifierForVendor!.uuidString
        return

        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    func setIsIDFATrackingEnabled() {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            contextProps["klerio_adv_id_not_allowed"] = false
        }else {
            contextProps["klerio_adv_id_not_allowed"] = true
        }
    }
    
    func setAnonymousID() {
        if contextProps["klerio_anonymous_id"] != nil{
             //saved value don't do use last one
        }else{
            //ToDo: remove later
            contextProps["klerio_anonymous_id"] = UIDevice.current.identifierForVendor!.uuidString
            return
            
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                contextProps["klerio_anonymous_id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }else{
                contextProps["klerio_anonymous_id"] = UIDevice.current.identifierForVendor!.uuidString
            }
        }
    }
        
        //    func setUserID() {
        //        if contextProps["id"] != nil{
        //            //saved value don't do use last one
        //        }
        //    }
        
        //    func setUUuserID() {
        //        //ToDo: remove later
        //        contextProps["id"] = UIDevice.current.identifierForVendor!.uuidString
        //        return
        //        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
        //            contextProps["id"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        //        }else{
        //            contextProps["id"] = UIDevice.current.identifierForVendor!.uuidString
        //        }
        //    }
        
        func setLaunctCount() {
            let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
            contextProps["klerio_launch_count"] = currentCount
        }
        
}
