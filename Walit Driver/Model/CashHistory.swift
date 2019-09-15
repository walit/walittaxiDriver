//
//  CashHistory.swift
//  Walit Driver
//
//  Created by Kavita on 17/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CashHistory: NSObject {
    var message : String!
    var dateTime : String!
    var amount :String!
    var image : String!
    func getData(dict:NSDictionary){
     self.message = dict.value(forKey: "comments") as? String
     self.dateTime = dict.value(forKey: "created_at") as? String
     self.amount = dict.value(forKey: "amount") as? String
     self.image = dict.value(forKey: "icon") as? String
    }
    
}
class RideHistory{

    var booking_number : String!
    var created_at : String!
    var customer_img : String!
    var customer_name : String!
    var date : String!
    var destination_address : String!
    
    var driver_address : String!
    var earning_amount : String!
    var first_milestone_distance : String!
    var first_milestone_duration : String!
    var origin_address : String!
    var payment_type : String!
    
    var ride_id : String!
    var ride_status : String!
    var second_milestone_distance : String!
    var second_milestone_duration : String!
    var time : String!
    var total_paid_price : String!
    func getData(dict:NSDictionary){
        self.booking_number = dict.value(forKey: "booking_number") as? String
        self.created_at = dict.value(forKey: "created_at") as? String
        self.customer_img = dict.value(forKey: "customer_img") as? String
        self.customer_name = dict.value(forKey: "customer_name") as? String
        
        self.date = dict.value(forKey: "date") as? String
        self.destination_address = dict.value(forKey: "destination_address") as? String
        self.driver_address = dict.value(forKey: "driver_address") as? String
        self.earning_amount = dict.value(forKey: "earning_amount") as? String
        
        self.first_milestone_distance = dict.value(forKey: "first_milestone_distance") as? String
        self.first_milestone_duration = dict.value(forKey: "first_milestone_duration") as? String
        self.origin_address = dict.value(forKey: "origin_address") as? String
        self.payment_type = dict.value(forKey: "payment_type") as? String
        
        
        self.ride_id = dict.value(forKey: "ride_id") as? String
        self.ride_status = dict.value(forKey: "ride_status") as? String
        self.second_milestone_distance = dict.value(forKey: "second_milestone_distance") as? String
        self.second_milestone_duration = dict.value(forKey: "second_milestone_duration") as? String
        
        self.time = dict.value(forKey: "time") as? String
        self.total_paid_price = dict.value(forKey: "total_paid_price") as? String
        
    }
}
