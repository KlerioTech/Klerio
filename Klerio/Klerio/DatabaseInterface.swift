//
//  DatabaseInterface.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import CoreData

final class DatabaseInterface {
    
    static let shared = DatabaseInterface()
    
    func save(event: EventModel) {
//        self.database.save(event: event)
        BatchManager.shared.send(event: event)
        
        let strEntityName = "KlerioEvent"//getStringFromClass(aClassName: type)
        let entityDescription = NSEntityDescription.entity(forEntityName: strEntityName, in: KlerioDatabase.sharedInstance.managedObjectContext)

    }
    
    func remove(eventWithIds eventIds: [String]) {
        
    }
    
}



