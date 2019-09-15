//
//  HistoryTableViewCell.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDropOF: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(_ rideHistory:RideHistory){
        self.lblName.text = rideHistory.customer_name
        self.lblTime.text = rideHistory.time
        self.lblAmount.text = rideHistory.total_paid_price
        self.imgUser.af_setImage(withURL: URL.init(string: rideHistory.customer_img)!)
        self.lblDropOF.text = rideHistory.destination_address
        self.lblPickUp.text = rideHistory.origin_address
        if  rideHistory.ride_status == "1"{
            self.lblStatus.text = " Complete "
        }else{
            self.lblStatus.text = " Cancel "
        }
        self.lblDistance.text = rideHistory.second_milestone_distance
        
        
    }
}
