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
    
    func send(event: EventModel) {
        
        /*Batch:
        size = 5
        add to batchArray
        if batchArray.cout == 5
        then send and batchArray = nil
        */
        self.sendBatchToAPI(events: [event])
    }
    
    private func sendBatchToAPI(events: [EventModel]) {
        
        apiService.postEventDataOperation(requestBody: ["testkey":"Test Val"]) {(httpAPIResponse) in
            
        }
    }
    
}
