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
        finalEventDict["event_id"] = "123"
        finalEventDict["event_type"] = "log_event"

        let dateString = DateFormatter.sharedDateFormatter.string(from: Date())
        var eventProperties: [String : Any] = ["event_name": eventName,"created_at":dateString]
        if let properties = properties {
            eventProperties.merge(properties) { (v1, v2) -> Any in
                return v1
            }
        }
        finalEventDict["event_properties"] = eventProperties
        
        let deviceProperties = DeviceProperties.getProperties()
        finalEventDict["device_properties"] = deviceProperties
        
        let  commonProperties = CommonProperties.getProperties()
        finalEventDict["common_properties"] = commonProperties

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
