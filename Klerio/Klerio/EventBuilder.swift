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
    
    func getCurrentMillis()->Double {
        return Double(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    func buildEvent(eventName: String, properties: [String:Any]?) {
        print("EventBuilder : buildEvent")
        
        var finalEventDict: [String : Any] = [String : Any]()
        let uuid = UUID().uuidString
        finalEventDict["event_id"] = uuid
        finalEventDict["post_type"] = "log_event"
        finalEventDict["event_name"] = eventName
        finalEventDict["event_time"] = getCurrentMillis
        
        finalEventDict["event_properties"] = properties
        
        let deviceProperties = DeviceProperties.getProperties()
        finalEventDict["device_properties"] = deviceProperties
        
        let userProperties = UserProperties.shared.getUserProperty(clientProperties: nil)
        finalEventDict["user_properties"] = userProperties

        DatabaseInterface.shared.save(event: finalEventDict)
    }
    
    func buildUserProperties(properties: [String:Any]) {
        print("EventBuilder : buildUserProp")
        
        var finalEventDict: [String : Any] = [String : Any]()
        let uuid = UUID().uuidString
        finalEventDict["event_id"] = uuid
        finalEventDict["post_type"] = "log_user_prop"
        finalEventDict["event_time"] = getCurrentMillis
                
        let deviceProperties = DeviceProperties.getProperties()
        finalEventDict["device_properties"] = deviceProperties
        
        let userProp = UserProperties.shared.getUserProperty(clientProperties: properties)
        finalEventDict["user_properties"] = userProp
        
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
