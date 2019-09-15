//
//  CompleteRideViewController.swift
//  Walit Driver
//
//  Created by Kavita on 12/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CompleteRideViewController: UIViewController {
    var rideId = String()
    
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblRideTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        HomeHandler.manager.taxiDriverIncomeHandler(requestID: self.rideId, completion: {result,_,completeRide in
            DispatchQueue.main.async {
                if result == true{
                    self.lblDate.text = completeRide.created_at
                    self.lblPrice.text = completeRide.earning_amount
                    self.lblPickUp.text = completeRide.origin_address
                    
                    self.lblDropOff.text = completeRide.destination_address
                    self.lblDistance.text = completeRide.distance
                    self.lblRideTime.text = completeRide.duration
                    self.lblBookingID.text = completeRide.booking_number
                }
            }
           
            
        })
        
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
       
    }
    
    @IBAction func btnBackHome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
