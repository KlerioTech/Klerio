//
//  EventBuilder.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

final class EventBuilder {
     static let shared = EventBuilder()
    
    func buildEvent(eventName: String, properties: [String:Any]?) {
        
        var eventProperties: [String : Any] = ["event_name": eventName, "created_at": Date()]
        if let properties = properties {
            eventProperties.merge(properties) { (v1, v2) -> Any in
                return v1
            }
        }
        let deviceProperties = DeviceProperties.getProperties()
        let  commonProperties = CommonProperties.getProperties()
        let model = EventModel(id: "123",
                               type: "log_event",
                               eventProperties: eventProperties,
                               deviceProperties: deviceProperties,
                               userProperties: ["user_name":"some"])
        DatabaseInterface.shared.save(event: model)
    }
    
}

struct EventModel {
    var id: String
    var type: String
    var eventProperties: [String: Any]
    var deviceProperties: [String: Any]
    var userProperties: [String: Any]
}
