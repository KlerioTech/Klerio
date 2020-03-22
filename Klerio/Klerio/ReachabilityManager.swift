//
//  ReachabilityManager.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import Alamofire

enum ReachabilityManagerStatus:Int {
    case isreachable
    case isNotReachable
}

@objcMembers class ReachabilityManager: NSObject {
    
    public static let REACHABILITY_NAME = "REACHABILITY_NAME"
    
    public static let sharedInstance = ReachabilityManager()
    let reachabilityManager = NetworkReachabilityManager()
    var isNetworkReachable = false
    private var listeners : [String:(ReachabilityManagerStatus)->Void] = [:]
    
    func addListener(identifier:String, listener:@escaping (ReachabilityManagerStatus)->Void){
        listeners[identifier] = listener
    }
    
    func removeListener(identifier:String){
        listeners[identifier] = nil
    }
    
    private override init() {
        super.init()
        isNetworkReachable = reachabilityManager?.isReachable ?? false
        reachabilityManager?.listener = { [weak self] status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                self?.reachable()
            case .reachable(.wwan):
                self?.reachable()
            case .notReachable:
                self?.notReachable()
            case .unknown :
                self?.notReachable()
            }
        }
        reachabilityManager?.startListening()
    }
    
    private func reachable(){
        self.isNetworkReachable = true
        for listener in listeners.values {
            listener(ReachabilityManagerStatus.isreachable)
        }
        
    }
    
    private func notReachable(){
        self.isNetworkReachable = false
        for listener in listeners.values {
            listener(ReachabilityManagerStatus.isNotReachable)
        }
    }
}
