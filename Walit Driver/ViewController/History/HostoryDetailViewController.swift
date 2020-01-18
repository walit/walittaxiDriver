//
//  HostoryDetailViewController.swift
//  Walit Driver
//
//  Created by Kavita on 29/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class HostoryDetailViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookingNumber: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSecondPickUp: UILabel!
    @IBOutlet weak var lblSecondDropOff: UILabel!
    @IBOutlet weak var lblSecondDistnace: UILabel!
    @IBOutlet weak var lblSecondTime: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    var history = RideHistory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = history.customer_name
        self.lblBookingNumber.text = "Booking N \(history.booking_number ?? "")"
        self.lblDate.text = history.date  + " " + history.time
        self.lblDistance.text = history.first_milestone_distance
        self.lblTime.text = history.first_milestone_duration
        self.lblPickup.text = history.origin_address
        self.lblDropOff.text = history.destination_address
        
        self.lblSecondPickUp.text = history.origin_address
        self.lblSecondDropOff.text = history.destination_address
        
        self.lblSecondTime.text = history.second_milestone_duration
        self.lblSecondDistnace.text = history.second_milestone_distance
        self.lblAmount.text = history.total_paid_price
        self.imgUser.af_setImage(withURL: URL.init(string: history.customer_img)!)
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}
