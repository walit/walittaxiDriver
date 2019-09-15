//
//  BankDetailsViewController.swift
//  Walit Driver
//
//  Created by Kavita on 07/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class BankDetailsViewController: UIViewController {

    @IBOutlet weak var lblAccountHolder: UILabel!
    
    @IBOutlet weak var viewBankDetails: UIView!
    
    
    @IBOutlet weak var btnAddDetails: UIButton!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var txtISFCCode: UILabel!
    
    var bank = Bank()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddDetails.isHidden = true
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        BankHandler.bankHandler.getDetailsBankHandler{result,success,_ in
            print(result)
            self.bank = result
            DispatchQueue.main.async {
                self.lblAccountHolder.text = result.account_holder_name
                self.lblAccountNumber.text = result.account_number
                self.txtISFCCode.text = result.ifsc
            
            if success == false{
                self.btnAddDetails.isHidden = false
                self.viewBankDetails.isHidden = true
            }else{
                self.btnAddDetails.isHidden = true
                self.viewBankDetails.isHidden = false
            }
          }
        }
    }
    @IBAction func btnMenu(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddBankDetailViewController") as! AddBankDetailViewController
        vc.bank = self.bank
        vc.isedit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddDetails(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddBankDetailViewController") as! AddBankDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
