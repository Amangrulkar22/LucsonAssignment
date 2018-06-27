//
//  LocationManager.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 27/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import Foundation
import CoreLocation

/// Location protocol
protocol LocationProtocol {
    func udpatedLocation(location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    /// Singleton instance of LocationManager
    static let sharedInstance = LocationManager()
    
    /// Create location manager object
    var locationManager = CLLocationManager()
    
    /// delegate object to call protocol method
    var delegate: LocationProtocol?
    
    override init() {
        super.init()
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK:- Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        delegate?.udpatedLocation(location: location!)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
}
