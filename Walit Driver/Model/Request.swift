//
//  Request.swift
//  Walit Driver
//
//  Created by Kavita on 12/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class Request: NSObject {
    var customer_first_name : String!
    var customer_image_url : String!
    var customer_last_name :String!
    var customer_phone : String!
    var destination_address : String!
    var destination_latitude : String!
    var destination_longitude : String!
    var origin_address : String!
    var origin_latitude : String!
    var origin_longitude : String!
    var request_id :String!
    var second_milestone_distance_text : String!
    var second_milestone_duration_text : String!
    var total_paid_price : String!
    var ride_id :String!
    var is_verified :String!
    var is_ride : String!
    var emit_data : NSDictionary!
    var customer_id : String!
     var payment_type : String!
    func getData(dict:NSDictionary){
        
        self.customer_first_name = dict.value(forKey: "customer_first_name") as? String
        self.customer_image_url = dict.value(forKey: "customer_image_url") as? String
        self.customer_last_name = dict.value(forKey: "customer_last_name") as? String
        self.destination_address = dict.value(forKey: "destination_address") as? String
        self.customer_phone = dict.value(forKey: "customer_phone") as? String
        
        self.destination_latitude = dict.value(forKey: "destination_latitude") as? String
        self.destination_longitude = dict.value(forKey: "destination_longitude") as? String
        
        
        self.origin_address = dict.value(forKey: "origin_address") as? String
        self.origin_latitude = dict.value(forKey: "origin_latitude") as? String
        self.origin_longitude = dict.value(forKey: "origin_longitude") as? String
        self.request_id = dict.value(forKey: "request_id") as? String
        
        self.second_milestone_distance_text = dict.value(forKey: "second_milestone_distance_text") as? String
         self.second_milestone_duration_text = dict.value(forKey: "second_milestone_duration_text") as? String
        self.total_paid_price = dict.value(forKey: "total_paid_price") as? String
        
        if let value = dict.value(forKey: "is_verified") as? String{
            self.is_verified = value
        }
        if let value = dict.value(forKey: "is_ride") as? String{
            self.is_ride = value
        }
        if let value = dict.value(forKey: "ride_id") as? String{
            self.ride_id = value
        }
        if let id = dict.value(forKey: "customer_id") as? String{
            customer_id = id
        }
        if let value = dict.value(forKey: "emit_data") as? NSDictionary{
            self.emit_data = value
            
        }
        if let id = dict.value(forKey: "payment_type") as? String{
            payment_type = id
        }
        
    }
    
}
