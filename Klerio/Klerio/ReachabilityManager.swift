//
//  ReachabilityManager.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/03/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import NetworkExtension

enum ReachabilityManagerStatus:Int {
    case isreachable
    case isNotReachable
}

@objcMembers class ReachabilityManager: NSObject {
    
    public static let REACHABILITY_NAME = "REACHABILITY_NAME"
    
    public static let sharedInstance = ReachabilityManager()
    let reachabilityManager = NetworkReachabilityManager()
    var isNetworkReachable = false
    var networkConnectionType:String = "offline"
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
                self?.reachableWithType(type: "wifi")
            case .reachable(.wwan):
                self?.reachableWithType(type: "mobile")
            case .notReachable:
                self?.notReachableWithType(type: "offline")
            case .unknown :
                self?.notReachableWithType(type: "offline")
            }
        }
        reachabilityManager?.startListening()
    }
    
    func getNetworkConnectionType() -> String {
        let status = reachabilityManager?.networkReachabilityStatus
        var type =  "offline"
        switch status {
        case .reachable(.ethernetOrWiFi):
            type = "wifi"
        case .reachable(.wwan):
            type = "mobile"
        case .notReachable:
            type = "offline"
        case .unknown :
            type = "offline"
        case .none: break
        }
        return type
    }
    
    private func reachableWithType(type: String){
        self.isNetworkReachable = true
        self.networkConnectionType = type
        for listener in listeners.values {
            listener(ReachabilityManagerStatus.isreachable)
        }
    }
    
    private func notReachableWithType(type: String){
        self.isNetworkReachable = false
        self.networkConnectionType = type
        for listener in listeners.values {
            listener(ReachabilityManagerStatus.isNotReachable)
        }
    }
    
    
    func getWiFiSSID() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    
    
    func getTelephonyCarrierName() -> String? {
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value else {
                // No carrier info available
                return nil
            }
            return carrier.carrierName
        }else{
            guard let carrier: CTCarrier = networkInfo.subscriberCellularProvider else {
                // No carrier info available
                return nil
            }
            return carrier.carrierName
        }
    }
    
    public var cellularNetworkType: String? {
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            let currCarrierType: String
            guard let dict = networkInfo.serviceCurrentRadioAccessTechnology, dict.count > 0  else{
                return nil
            }
            let key = dict.keys.first! // Apple assures is present...
            let carrierType = dict[key]
            currCarrierType = carrierType!
            switch currCarrierType {
            case CTRadioAccessTechnologyLTE:
                return "4G"
            case CTRadioAccessTechnologyeHRPD,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyWCDMA,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB:
                return "3G"
            case CTRadioAccessTechnologyEdge,
                 CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyCDMA1x:
                return "2G"
            default:
                return "unknown"
            }
        }else{
            guard let radioAccessTechnology = networkInfo.currentRadioAccessTechnology else {
                return nil
            }
            switch radioAccessTechnology {
            case CTRadioAccessTechnologyLTE:
                return "4G"
            case CTRadioAccessTechnologyeHRPD,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyWCDMA,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB:
                return "3G"
            case CTRadioAccessTechnologyEdge,
                 CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyCDMA1x:
                return "2G"
            default:
                return "unknown"
            }
        }
    }

}
