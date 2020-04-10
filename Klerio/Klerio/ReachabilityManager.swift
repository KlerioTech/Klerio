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
        
//        self.getWifiInfo()
//        self.getWiFiName()
//        self.getNetworkType()
//        self.getTelephonyInfo()
        

    }
    
    private func notReachable(){
        self.isNetworkReachable = false
        for listener in listeners.values {
            listener(ReachabilityManagerStatus.isNotReachable)
        }
    }
    
    
    func getWiFiName() -> String? {
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
    
    func getNetworkType() -> String? {
        let networkInfo = CTTelephonyNetworkInfo()
        let networkString = networkInfo.currentRadioAccessTechnology

        if networkString == CTRadioAccessTechnologyLTE{
          // LTE (4G)
        }else if networkString == CTRadioAccessTechnologyWCDMA{
          // 3G
        }else if networkString == CTRadioAccessTechnologyEdge{
          // EDGE (2G)
        }
        return ""
    }
    
    func getTelephonyInfo()->String?{
        let networkInfo = CTTelephonyNetworkInfo()
        let currCarrierType: String?
        if #available(iOS 12.0, *) {
//            let serviceSubscriberCellularProviders = networkInfo.serviceSubscriberCellularProviders

            // get curr value:
            guard let dict = networkInfo.serviceCurrentRadioAccessTechnology else{
                return nil
            }
            // as apple states
            // https://developer.apple.com/documentation/coretelephony/cttelephonynetworkinfo/3024510-servicecurrentradioaccesstechnol
            // 1st value is our string:
            let key = dict.keys.first! // Apple assures is present...

            // use it on previous dict:
            let carrierType = dict[key]

            // to compare:
            guard networkInfo.currentRadioAccessTechnology != nil else {
                return nil
            }
            currCarrierType = carrierType

        } else {
            // Fall back to pre iOS12
            guard let carrierType = networkInfo.currentRadioAccessTechnology else {
                return nil
            }
            currCarrierType = carrierType
        }


        switch currCarrierType{
        case CTRadioAccessTechnologyGPRS:
            return "2G" + " (GPRS)"

        case CTRadioAccessTechnologyEdge:
            return "2G" + " (Edge)"

        case CTRadioAccessTechnologyCDMA1x:
            return "2G" + " (CDMA1x)"

        case CTRadioAccessTechnologyWCDMA:
            return "3G" + " (WCDMA)"

        case CTRadioAccessTechnologyHSDPA:
            return "3G" + " (HSDPA)"

        case CTRadioAccessTechnologyHSUPA:
            return "3G" + " (HSUPA)"

        case CTRadioAccessTechnologyCDMAEVDORev0:
            return "3G" + " (CDMAEVDORev0)"

        case CTRadioAccessTechnologyCDMAEVDORevA:
            return "3G" + " (CDMAEVDORevA)"

        case CTRadioAccessTechnologyCDMAEVDORevB:
            return "3G" + " (CDMAEVDORevB)"

        case CTRadioAccessTechnologyeHRPD:
            return "3G" + " (eHRPD)"

        case CTRadioAccessTechnologyLTE:
            return "4G" + " (LTE)"

        default:
            break;
        }

        return "newer type!"
    }
    
    struct WifiInfo {
            public let interface:String
            public let ssid:String
            public let bssid:String
            init(_ interface:String, _ ssid:String,_ bssid:String) {
                self.interface = interface
                self.ssid = ssid
                self.bssid = bssid
            }
        }
        
        func getWifiInfo() -> Array<WifiInfo> {
            guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
                return []
            }
            let wifiInfo:[WifiInfo] = interfaceNames.compactMap{ name in
                guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                    return nil
                }
                guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                    return nil
                }
                guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                    return nil
                }
                return WifiInfo(name, ssid,bssid)
            }
            return wifiInfo
        }
    
}
