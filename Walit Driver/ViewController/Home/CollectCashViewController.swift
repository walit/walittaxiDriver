//
//  CollectCashViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import SocketIO
class CollectCashViewController: UIViewController {
    var reuest = Request()
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var lblRideTime: UILabel!
    @IBOutlet weak var lblDiscountAmt: UILabel!
    @IBOutlet weak var lblTotalApidAmount: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    
    @IBOutlet weak var lblCollectCash: UILabel!
    
    @IBOutlet weak var btnCashORWallet: RoundButton!
    let manager = SocketManager.init(socketURL: URL(string:"http://132.148.145.112:2022")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.lblUserName.text = self.reuest.customer_first_name + " " + self.reuest.customer_last_name
        self.lblPrice.text =   self.reuest.total_paid_price
        self.lblPickupAddress.text = self.reuest.origin_address
        self.lblDropOff.text = self.reuest.destination_address
        self.lblRideTime.text = "Time: " + self.reuest.second_milestone_duration_text
        self.lblDiscountAmt.text = "0.0"
        self.lblPaidAmount.text =  self.reuest.total_paid_price
        self.lblTotalApidAmount.text =   self.reuest.total_paid_price
        self.lblCollectCash.text = self.reuest.second_milestone_distance_text
        let strImage = self.reuest.customer_image_url
        
        let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgUser.af_setImage(withURL: url)
        }
        else{
            self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        if reuest.payment_type == "CASH"{
            self.btnCash.isUserInteractionEnabled = true
            self.btnCash.setTitle("Cash", for: .normal)
        }else{
            self.btnCash.setTitle("Wallet", for: .normal)
            self.btnCash.isUserInteractionEnabled = false
        }
        socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            self.connectSocket()
        }
       
    }
    func connectSocket(){
        socket.on("get change payment method") { (items, ackEmitter) in
            print(items)
           
            if self.reuest.payment_type == "CASH"{
               self.reuest.payment_type = "Wallet"
                self.btnCash.setTitle("Wallet", for: .normal)
                self.btnCash.isUserInteractionEnabled = false
            }else{
                self.reuest.payment_type = "CASH"
                self.btnCash.setTitle("Cash", for: .normal)
                self.btnCash.isUserInteractionEnabled = true
            }
        }
        socket.on("get payment complete") { (items, ackEmitter) in
            HomeHandler.manager.completeRideHandler(requestID: self.reuest.ride_id, completion: {sccess,_,_ in
                DispatchQueue.main.async {
                    if sccess == true{
                        
                        let dict = ["customer_id":self.reuest.customer_id] as? [String:Any]
                        self.socket.emit("cash collect",dict!)
                        let vc  =  self.storyboard?.instantiateViewController(withIdentifier: "CompleteRideViewController") as! CompleteRideViewController
                        vc.rideId = self.reuest.ride_id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            })
        }
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
        self.imgUser.clipsToBounds = true
     }
 
    @IBAction func btnCollect(_ sender: Any) {
        let dict = ["customer_id":self.reuest.customer_id] as? [String:Any]
        self.socket.emit("cash collect",dict!)
        HomeHandler.manager.completeRideHandler(requestID: self.reuest.ride_id, completion: {sccess,_,_ in
            DispatchQueue.main.async {
                if sccess == true{
                    let vc  =  self.storyboard?.instantiateViewController(withIdentifier: "CompleteRideViewController") as! CompleteRideViewController
                    vc.rideId = self.reuest.ride_id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        })
      
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
