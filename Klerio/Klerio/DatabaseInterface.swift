//
//  DatabaseInterface.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import CoreData

final class DatabaseInterface:NSObject {
    
    static let shared = DatabaseInterface()
    
    func save(event: EventModel) {
        BatchManager.shared.send(event: event)
        
        do {
            let jsonData = try JSONEncoder().encode(event)
            self.saveEventData(eventData: jsonData)
        } catch { print(error) }
        
        self.getEventData()
    }
    
    func remove(eventWithIds eventIds: [String]) {
        
    }
    
    func saveEventData(eventData : Data?) {
        if let receivedData =  eventData {
            var klerioEvent = DatabaseInterface.getModelObject(KlerioEvent.self, predicate: nil)
            if klerioEvent == nil {
                klerioEvent = DatabaseInterface.insertModelObject(KlerioEvent.self)
            }
            klerioEvent?.eventData = receivedData as Data
            KlerioDatabase.sharedInstance.saveContext()
        }
    }
    
    func getEventData() ->  EventModel? {
        print("getEventData()")
        let klerioEvent = DatabaseInterface.getModelObject(KlerioEvent.self, predicate: nil)
        if let recivedData = klerioEvent?.eventData as Data? {
            if let responseDict = DatabaseInterface.getDictionaryObject(responseData: recivedData) {
                print("Retrived Event = ",responseDict)
            }
        }
        return nil
    }
}

extension DatabaseInterface {
    static func getDictionaryObject(responseData:Data) -> Dictionary<String, Any>? {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: responseData, options:JSONSerialization.ReadingOptions(rawValue: 0))
                guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                    print("Not a Dictionary")
                    return nil
                }
                return dictionary
            } catch {
                print(error)
                return nil
            }
    }
    
    static func getModelObject<T:NSManagedObject>(_ type: T.Type, predicate: NSPredicate?) -> T?{
        let strEntityName = getStringFromClass(aClassName: type)
        let entityDescription = NSEntityDescription.entity(forEntityName: strEntityName, in: KlerioDatabase.sharedInstance.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        if predicate != nil {
            request.predicate = predicate
        }
        request.entity = entityDescription
        request.returnsObjectsAsFaults = false
        var array = [NSManagedObject]()
        let error: Error? = nil
        let backgroundContaxt: NSManagedObjectContext = KlerioDatabase.sharedInstance.managedObjectContext
        backgroundContaxt.performAndWait({
            if let execute = try? backgroundContaxt.fetch(request) {
                array = execute as! [NSManagedObject]
            }
        })
        if error != nil {
            //LOG Error
        }
        if array.count > 0 {
            return array.last as? T
        }
        return nil
    }
    
    static func insertModelObject<T:NSManagedObject>(_ type: T.Type) -> T?{
        let strEntityName = getStringFromClass(aClassName: type)
        var entity: NSManagedObject? = nil
        let backgroundContaxt: NSManagedObjectContext = KlerioDatabase.sharedInstance.managedObjectContext
        backgroundContaxt.performAndWait({
            entity = NSEntityDescription.insertNewObject(forEntityName: strEntityName, into: KlerioDatabase.sharedInstance.managedObjectContext)
        })
        return entity as? T
    }
}



