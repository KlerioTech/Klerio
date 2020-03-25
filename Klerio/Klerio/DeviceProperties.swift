//
//  DeviceProperties.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 22/02/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AdSupport

class DeviceProperties {
    static var contextProps:[String:Any] = [String:Any]()

    static func getProperties() -> [String:Any] {
        addSdkProps()
        addDeviceProps()
        addOsInfo()
        addDisplayInfo()
        addConsumerInfo()
        return contextProps
    }
    
    //  sdk         : done
    //  device      : done
    //  display     : done
    //  consumer    : wip
    //location
    //os
    //network - dynamic
    
    static func addSdkProps() {
        contextProps["sdk_name"] = "sdk-ios"
        contextProps["sdk_version"] = "1.0.0"
    }
    
    static func addDeviceProps() {
        #if targetEnvironment(simulator)
        contextProps["device_is_emulator"] = "true";
        #else
        contextProps["device_is_emulator"] = "false";
        #endif
        
        contextProps["device_model"] = UIDevice.current.modelName
        contextProps["device_vendor"] = "Apple"
        contextProps["device_name"] = UIDevice.current.model
        contextProps["device_type"] = UIDevice.current.model
        contextProps["device_timezone"] = TimeZone.current.identifier
        contextProps["device_language"] = Locale.current.languageCode
        contextProps["device_country"] = Locale.current.regionCode
        contextProps["device_id"] = UIDevice.current.identifierForVendor!.uuidString
        let webView = UIWebView(frame: CGRect.zero)
        contextProps["device_user_agent"] = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
    }
    
    static func addOsInfo() {
        contextProps["device_os_version"] = UIDevice.current.systemVersion
        contextProps["device_platform"] = "iOS"
    }
    
    static func addDisplayInfo() {
        let screenSize = UIScreen.main.bounds
        contextProps["device_width"] = "\(screenSize.width)"
        contextProps["device_height"] = "\(screenSize.height)"
        contextProps["device_ios_scale"] = "\(UIScreen.main.scale)"
    }
    
    static func addConsumerInfo() {
        contextProps["sdk_consumer"] = Bundle.main.infoDictionary?["CFBundleName"] as? String
        contextProps["sdk_consumer_ios_pkg_type"] = Bundle.main.infoDictionary?["CFBundlePackageType"] as? String
        contextProps["sdk_consumer_version_code"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        contextProps["sdk_consumer_ios_bundle"] =  Bundle.main.bundleIdentifier
        contextProps["sdk_consumer_app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}


public extension UIDevice {
    /// pares the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
}
