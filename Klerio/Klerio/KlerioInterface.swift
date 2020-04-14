//
//  KlerioInterface.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation

public protocol KlerioProtocol {
    func didCallSendEvent()
}

public final class Klerio {
    public static let shared = Klerio()
    public var delegate: KlerioProtocol?
     
    public func InitSdk() {
        print("Init Klerio")
        // get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")

        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")

        BatchManager.shared.startBatchPerodicTimer()
    }
    
    public func collect (eventName: String, eventProperties: [String:Any]?) {
        print("Evnt Name : \(eventName)")
        EventBuilder.shared.buildEvent(eventName: eventName, properties: eventProperties)
        Klerio.shared.delegate?.didCallSendEvent()
    }
    
    public func collect (userProperties: [String:Any]?) {
        if !(userProperties?.isEmpty ?? true) {
            EventBuilder.shared.buildUserProperties(properties: userProperties!)
        }
    }
}
