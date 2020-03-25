//
//  BatchManager.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 23/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

final class BatchManager {
    
    static let shared = BatchManager()
    private var batchArray: [EventModel]?
    private var apiService: APIService = APIService(httpClientObj: HTTPClient.shared)
    private var batchSize = 5
    
    func sendEventBatch() {
        //TODO: If required chnage logic based on batch size until batch not full don't send.
        if let retrivedKlerioEventArray = DatabaseInterface.shared.getEvents(batchSize: batchSize) {
            BatchManager.shared.send(events: retrivedKlerioEventArray)
        }
    }
    
    func sendQueuedEventFromDB() {
        // TODO: chnage if required sync call
        if let retrivedKlerioEventArray = DatabaseInterface.shared.getEventData(),retrivedKlerioEventArray.count > 0{
            let results = retrivedKlerioEventArray.chunked(into: batchSize)
            for batchArray in results {
                BatchManager.shared.send(events: batchArray)
            }
        }
    }
    
    func send(events : [KlerioEvent]) {
        self.sendBatchToAPI(events: events)
    }
    
    private func sendBatchToAPI(events : [KlerioEvent]) {
        print("Batch started:",events.count)
        
        var batchDictArray: [[String : Any]] = [[String : Any]]()
        for event in events {
            if let responseDict = DatabaseInterface.getDictionaryObject(responseData: event.eventData!) {
                batchDictArray.append(responseDict)
            }
        }
        var batchDict: [String:Any] = [String:Any]()
        batchDict["event_batch"] = batchDictArray
        apiService.postEventDataOperation(requestBody: batchDict) {(httpAPIResponse) in
//            if httpAPIResponse.status.statusCode == HTTPStatusCode.Success.rawValue {
                for event in events {
                    DatabaseInterface.shared.remove(eventId:event.eventID)
                }
                print("Batch completed")
//            }
        }
    }
}
