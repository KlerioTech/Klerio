//
//  APIService.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 23/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

protocol APIService {
    func send(events: [EventModel])
}

final class KlerioAPIClient: APIService {
    
    func send(events: [EventModel]) {
        //TODO: implement this
        
        //if success
        DatabaseInterface.shared.remove(eventWithIds: events.map { $0.id })
    }
}
