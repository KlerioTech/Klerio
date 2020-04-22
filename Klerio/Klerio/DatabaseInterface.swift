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
    
    func saveUserProperty(userProp: [String : Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userProp, options: .prettyPrinted)
            self.saveUserPropertyData(userProp: jsonData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(event: [String : Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: event, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
            }
            self.saveEventData(eventData: jsonData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func remove(eventId: Int64) {
        let context = KlerioDatabase.sharedInstance.managedObjectContext
        let fetchPredicate = NSPredicate(format: "eventID == %d",eventId)
        let fetchEvent = NSFetchRequest<NSFetchRequestResult>(entityName: "KlerioEvent")
        fetchEvent.predicate  = fetchPredicate
        fetchEvent.returnsObjectsAsFaults   = false
        do {
            let items = try context?.fetch(fetchEvent) as! [NSManagedObject]
            for item in items {
                context?.delete(item)
                print("removed ID:",eventId)
            }
            KlerioDatabase.sharedInstance.saveContext()
        } catch {
            print(error.localizedDescription)
        }
        
        self.getEventData()
    }
    
    func saveUserPropertyData(userProp : Data?) {
        if let receivedData =  userProp {
            var userPropData = DatabaseInterface.getModelObject(KlerioUser.self, predicate: nil)
            if userPropData == nil {
                userPropData = DatabaseInterface.insertModelObject(KlerioUser.self)
            }
            userPropData?.userData  = receivedData as Data
            KlerioDatabase.sharedInstance.saveContext()
        }
    }
    
    func saveEventData(eventData : Data?) {
        if let receivedData =  eventData {
            let klerioEvent = DatabaseInterface.insertModelObject(KlerioEvent.self)
            klerioEvent?.eventData = receivedData as Data
            klerioEvent?.eventID = Int64(DatabaseInterface.getMaxID())
            KlerioDatabase.sharedInstance.saveContext()
        }
    }
    
    func getEventData() ->  [KlerioEvent]? {
        print("getEventData()")
        return DatabaseInterface.getAllEvents()
    }
    
    func getUserProperty() -> [String : Any]?{
        if let retrivedJsonData = DatabaseInterface.getModelObject(KlerioUser.self, predicate: nil) {
            if let userPropData = (retrivedJsonData.userData as Data?) {
                return DatabaseInterface.getDictionaryObject(responseData: userPropData)
            }
        }
        return nil
    }
    
    func getEvents(batchSize : Int) -> [KlerioEvent]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KlerioEvent")
        fetchRequest.fetchLimit = batchSize
        do {
            let results = try KlerioDatabase.sharedInstance.managedObjectContext.fetch(fetchRequest)
            print("Total records",results.count)
            return results as? [KlerioEvent]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return nil
    }
}

extension DatabaseInterface {
    static func getCountForEvent() -> Int {
        let moc = KlerioDatabase.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KlerioEvent")
        let count = try! moc!.count(for: fetchRequest)
        return count+1
    }
    
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
    
    static func getAllEvents() -> [KlerioEvent]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KlerioEvent")
        do {
            let results = try KlerioDatabase.sharedInstance.managedObjectContext.fetch(fetchRequest)
            print("Total records",results.count)
            return results as? [KlerioEvent]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return nil
    }
    
    static func getMaxID() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KlerioEvent")
        let sortDescriptor = NSSortDescriptor(key: "eventID", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try KlerioDatabase.sharedInstance.managedObjectContext.fetch(fetchRequest) as? [KlerioEvent]
            if let event = results?.last {
                print("MaxID Count",Int (event.eventID) + 1)
                return Int (event.eventID) + 1
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return 1
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



