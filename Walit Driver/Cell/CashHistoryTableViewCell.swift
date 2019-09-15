//
//  CashHistoryTableViewCell.swift
//  Walit Driver
//
//  Created by Kavita on 17/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class CashHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(cashHistory:CashHistory){
        self.lblMessage.text = cashHistory.message
        self.lblPrice.text = cashHistory.amount
        self.lblDateTime.text = cashHistory.dateTime
        self.img.af_setImage(withURL: URL.init(string: cashHistory.image)!)
    }
}
