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
        
    }
    
    public func collect (eventName: String, eventProperties: [String:Any]?) {
        print("Evnt Name : \(eventName)")
        EventBuilder.shared.buildEvent(eventName: eventName, properties: eventProperties)
        Klerio.shared.delegate?.didCallSendEvent()
    }
    
    public func collect (userProperties: [String:Any]?) {
    }
}
