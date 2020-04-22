//
//  EventBuilder.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}

final class EventBuilder {
     static let shared = EventBuilder()
    
    func buildEvent(eventName: String, properties: [String:Any]?) {
        print("EventBuilder : buildEvent")
        
        var finalEventDict: [String : Any] = [String : Any]()
        let uuid = UUID().uuidString
        finalEventDict["event_id"] = uuid
        finalEventDict["post_type"] = "log_event"
        let dateString = DateFormatter.sharedDateFormatter.string(from: Date())
        finalEventDict["event_name"] = eventName
        finalEventDict["created_at"] = dateString
        
        finalEventDict["event_properties"] = properties
        
        let deviceProperties = DeviceProperties.getProperties()
        finalEventDict["device_properties"] = deviceProperties
        
        let  userProperties = UserProperties.getProperties()
        finalEventDict["user_properties"] = userProperties

        DatabaseInterface.shared.save(event: finalEventDict)
    }
    
    func buildUserProperties(properties: [String:Any]) {
        print("EventBuilder : buildUserProp")
        
        var finalEventDict: [String : Any] = [String : Any]()
        let uuid = UUID().uuidString
        finalEventDict["event_id"] = uuid
        finalEventDict["post_type"] = "log_user_prop"
        let dateString = DateFormatter.sharedDateFormatter.string(from: Date())
        finalEventDict["created_at"] = dateString
                
        let deviceProperties = DeviceProperties.getProperties()
        finalEventDict["device_properties"] = deviceProperties
        
        let  userProperties = UserProperties.getProperties()
        DatabaseInterface.shared.saveUserProperty(userProp: userProperties)
        
        if let userProperty1 = DatabaseInterface.shared.getUserProperty() {
            var mergedProperties = properties
            mergedProperties.merge(userProperty1) { (v1, v2) -> Any in
                    return v1
                }
            finalEventDict["user_properties"] = mergedProperties
        }
        DatabaseInterface.shared.save(event: finalEventDict)
    }
}

struct EventModel: Codable {
    var id: String
    var type: String
//    var eventProperties: [String: Any]
//    var deviceProperties: [String: Any]
//    var userProperties: [String: Any]
}
