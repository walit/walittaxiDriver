//
//  User.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var access_token : String!
    var driver_id : String!
    var email : String!
    var first_name : String!
    var image : String!
    var last_name :String!
    var latitude : String!
    var longitude : String!
    var phone : String!
    var refer_code : String!
    var taxi_title: String!
    func setData(dict: NSDictionary) {
        self.access_token = dict.value(forKey: "access_token") as? String
        self.driver_id = dict.value(forKey: "driver_id") as? String
        self.email = dict.value(forKey: "email") as? String
        self.first_name = dict.value(forKey: "first_name") as? String
        self.image = dict.value(forKey: "image") as? String
        self.last_name = dict.value(forKey: "last_name") as? String
        self.latitude = dict.value(forKey: "latitude") as? String
        self.longitude = dict.value(forKey: "longitude") as? String
        self.phone = dict.value(forKey: "phone") as? String
        self.refer_code = dict.value(forKey: "refer_code") as? String
        self.taxi_title = dict.value(forKey: "taxi_title") as? String
    }
}
