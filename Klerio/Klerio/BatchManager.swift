//
//  BatchManager.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 23/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

final class BatchManager {
    
    static let shared = BatchManager()
    private var batchArray: [EventModel]?
    private var apiService: APIService = APIService(httpClientObj: HTTPClient.shared)
    
    func sendQueuedEventFromDB() {
        // check N/W and continue
        if let retrivedKlerioEventArray = DatabaseInterface.shared.getEventData() {
            for event in retrivedKlerioEventArray {
                BatchManager.shared.send(event: event)
            }
        }
    }
    
    func send(event: KlerioEvent) {
        /*Batch:
        size = 5
        add to batchArray
        if batchArray.cout == 5
        then send and batchArray = nil
        */
        self.sendBatchToAPI(event: event)
    }
    
    private func sendBatchToAPI(event: KlerioEvent) {
        if let responseDict = DatabaseInterface.getDictionaryObject(responseData: event.eventData!) {
            apiService.postEventDataOperation(requestBody: responseDict) {(httpAPIResponse) in
                if httpAPIResponse.status.statusCode == HTTPStatusCode.Success.rawValue {
                    DatabaseInterface.shared.remove(eventId:event.eventID)
                }
            }
        }
    }
}
