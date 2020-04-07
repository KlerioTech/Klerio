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
    private var batchTimer: Timer?
    
    func startBatchPerodicTimer() {
        batchTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        if ReachabilityManager.sharedInstance.isNetworkReachable {
            self.sendQueuedEventFromDB()
        }
    }
    
    //    func sendEventBatch() {
    //        //TODO: If required chnage logic based on batch size until batch not full don't send.
    //        if let retrivedKlerioEventArray = DatabaseInterface.shared.getEvents(batchSize: batchSize) {
    //            BatchManager.shared.send(events: retrivedKlerioEventArray)
    //        }
    //    }
    
    var eventArray = [[KlerioEvent]]()
    var isBatchDataSending:Bool = false
    func sendQueuedEventFromDB() {
        // TODO: chnage if required sync call
        if !isBatchDataSending {
            if let retrivedKlerioEventArray = DatabaseInterface.shared.getEventData(),retrivedKlerioEventArray.count > 0{
                print("started ......")
                eventArray = retrivedKlerioEventArray.chunked(into: KlerioConstant.BATCH_SIZE)
                self.sendBatch(batch: eventArray[0], batchCount:0, completion: { (success) -> Void in
                    if success {
                        print("Batch Data send successfuly")
                    }else{
                        print("Sending batch data....")
                    }
                })
            }
        }else{
            print("New batch not yet started")
        }
    }
    
    func loopTotalBatch() {
        
    }
    
    func sendBatch(batch: [KlerioEvent], batchCount: Int, completion: @escaping (Bool) -> Void) {
        isBatchDataSending = true
        if batchCount >  eventArray.count {
            print("Completed batch")
            isBatchDataSending = false
            completion(true)
        } else {
            self.sendBatchToAPI(events: batch) { [weak self](success) in
                if success {
                    let nextIndex = batchCount+1
                    print("Next Index to send:",nextIndex)
                    if nextIndex < self?.eventArray.count ?? 0 {
                        self?.sendBatch(batch: (self?.eventArray[nextIndex])!, batchCount: nextIndex) {[weak self] (success) in
                            completion(false)
                        }
                    }else{
                        print("Completed all batch")
                        self?.isBatchDataSending = false
                        completion(true)
                    }
                }else{
                    print("retrying batch")
                    self!.sendBatch(batch: self!.eventArray[batchCount], batchCount: batchCount) {[weak self] (success) in
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func sendBatchToAPI(events : [KlerioEvent],completion: @escaping (Bool) -> Void){
        print("Batch started:",events.count)
        
        var batchDictArray: [[String : Any]] = [[String : Any]]()
        for event in events {
            if let responseDict = DatabaseInterface.getDictionaryObject(responseData: event.eventData!) {
                batchDictArray.append(responseDict)
            }
        }
        var batchDict: [String:Any] = [String:Any]()
        batchDict["payload"] = batchDictArray
        apiService.postEventDataOperation(requestBody: batchDict) {(httpAPIResponse) in
            if httpAPIResponse.status.statusCode == HTTPStatusCode.Success.rawValue {
                for event in events {
                    DatabaseInterface.shared.remove(eventId:event.eventID)
                }
                print("Batch completed")
                completion(true)
            }else{
                completion(false)
            }
        }
    }
}
