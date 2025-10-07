//
//  LocationFile.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 9/7/25.
//

import Foundation
import CoreLocation

class LocationClass1:NSObject, ObservableObject, CLLocationManagerDelegate{
    
    //I cannot change the return types of the delagate methods. What If I make
    //those methods meodify values of this class, and create getter metthods for those.
    //Or just access them through the dot operator.
    
    //MARK: Performance Variables
    private var locationManager = CLLocationManager()
    
    private var GeocodeManager = CLGeocoder()
    
    private var passenger_location_object_ = CLLocation()
    //MARK: Primative Variables
    
    
    
    
    //MARK: Location Delegate Methods
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print ("Location Allowed")
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            print("Location access denied or restricted")
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let passenger_location_object = locations.last {
            passenger_location_object_ = passenger_location_object
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: any Error) {
        
    }
    
    //MARK: Geocoder Class Methods
    
    func callReverseGeocode (_ completionHandeler: @escaping ([CLPlacemark]?, (any Error)?) -> Void) {
        
        GeocodeManager.reverseGeocodeLocation (passenger_location_object_,completionHandler: completionHandeler)
        
        
    }
    
    //MARK: My own methods

    func getPassengerLocationObject() -> CLLocation {
        return passenger_location_object_
    }
    
    func getAuthorizationStatus () -> CLAuthorizationStatus {
        
        return locationManager.authorizationStatus
    }
    
    
}
