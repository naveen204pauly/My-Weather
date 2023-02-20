//
//  LocationService.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import Foundation
import CoreLocation


protocol LocationServiceProtocol:AnyObject {
    func onReceiveCoordinates(location: CLLocation)
}
class LocationService: CLLocationManager, CLLocationManagerDelegate {
    
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        self.requestAlwaysAuthorization()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            manager.requestAlwaysAuthorization()
        }
        if (manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways) {
            guard let currentLocation = manager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        if manager.authorizationStatus == .denied {
            print("User denied the location service")
        }
    }
}
