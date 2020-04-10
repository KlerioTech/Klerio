//
//  LocationManager.swift
//  Klerio
//
//  Created by Swapnil Jagtap on 09/04/20.
//  Copyright © 2020 Swapnil Jagtap. All rights reserved.
//
import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static var exposedLocation: CLLocation? {
        let locationManager = CLLocationManager()
        return locationManager.location
    }
    
    static func getPlace(for location: CLLocation,
                         completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
    
    override init() {
        super.init()
    }
}



