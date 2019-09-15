


//
//  CompleteRide.swift
//  Walit Driver
//
//  Created by Kavita on 23/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CompleteRide: NSObject {
    var booking_number : String!
    var created_at : String!
    var destination_address : String!
    var distance : String!
    var duration : String!
    var earning_amount : String!
    var origin_address : String!
    var ride_id : String!
    
    
    
    func getData(dict:NSDictionary){
        self.booking_number = dict.value(forKey: "booking_number") as? String
        self.created_at = dict.value(forKey: "created_at") as? String
        self.destination_address = dict.value(forKey: "destination_address") as? String
        
        self.distance = dict.value(forKey: "distance") as? String
        self.duration = dict.value(forKey: "duration") as? String
        self.earning_amount = dict.value(forKey: "earning_amount") as? String
        
        self.origin_address = dict.value(forKey: "origin_address") as? String
        self.ride_id = dict.value(forKey: "ride_id") as? String
    }
}
