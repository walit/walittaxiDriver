//
//  SideMenuTableViewCell.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    var arr = ["Home","Ride History","Profile","Cash History","Help","Complain","Setting","Bank details","Privacy Policy","Terms of Use"]
    var arrimages = ["home (1)","icon_all_order","icon_user_default","icon_all_order","icon_all_order","icon_all_order","icon_setting","icon_money","icon_privacy_policy","icon_privacy_policy","icon_privacy_policy"]
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(index:Int){
        self.lblTitle.text = arr[index]
        self.img.image = UIImage(named: arrimages[index])
    }
}
