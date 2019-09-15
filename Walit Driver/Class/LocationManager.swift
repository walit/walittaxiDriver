//
//  LocationManager.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import CoreLocation
class LocationManager: NSObject,CLLocationManagerDelegate {
   
   
    static let manager = LocationManager()
    let locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var callback: (() -> ())?
    func startLocation(){
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.distanceFilter = 100.0
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            print("PLease turn on location services or GPS")
        }
    }
    //MARK:- CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
       
        
        self.updateLocation(lat: "\( self.latitude)", long: "\( self.longitude)")
        NotificationCenter.default.post(name: Notification.Name("updatelocation"), object: nil, userInfo: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
    func updateLocation(lat:String,long:String){
        LoginHandler.manager.LatLongUpdateHandler(longitude: long, latitude: lat, completion: {_,_ in
            self.callback?()
        })
        
    }
}

