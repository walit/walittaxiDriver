//
//  Bank.swift
//  Walit Driver
//
//  Created by Kavita on 08/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class Bank: NSObject {
    var account_holder_name : String!
    var account_number : String!
    var ifsc : String!
    func getData(dict:NSDictionary){
        self.account_holder_name = dict.value(forKey: "account_holder_name") as? String
        self.account_number = dict.value(forKey: "account_number") as? String
        self.ifsc = dict.value(forKey: "ifsc") as? String
    }
}
