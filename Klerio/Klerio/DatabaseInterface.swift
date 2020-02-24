//
//  DatabaseInterface.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

final class DatabaseInterface {
    
    static let shared = DatabaseInterface()
    private var database: Database = KlerioDatabase()
    
    func save(event: EventModel) {
        self.database.save(event: event)
        BatchManager.shared.send(event: event)
    }
    
    func remove(eventWithIds eventIds: [String]) {
        
    }
    
}



