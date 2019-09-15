//
//  AddBankDetailViewController.swift
//  Walit Driver
//
//  Created by Kavita on 07/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class AddBankDetailViewController: UIViewController {

    
    @IBOutlet weak var btnSave: UIButton!
    
    
    @IBOutlet weak var txtAccountHodler: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAcccConfrim: UITextField!
    @IBOutlet weak var txtIFSCCode: UITextField!
    var bank = Bank()
    var isedit = false
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isedit == true {
        self.txtIFSCCode.text = self.bank.ifsc
        self.txtAccountHodler.text = self.bank.account_holder_name
        self.txtAccountNumber.text = self.bank.account_number
        self.txtAcccConfrim.text = self.bank.account_number
        self.btnSave.setTitle("Update Account", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAddDetails(_ sender: Any) {
        if txtAccountHodler.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter account holder name.")
            return
        }else if txtAccountNumber.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter account number.")
            return
        }else if txtAcccConfrim.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please confrim account number.")
            return
        }else if txtIFSCCode.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter IFSC code.")
            return
        }else{
            self.saveData()
        }
        
    }
    func saveData(){
        BankHandler.bankHandler.saveBankDetailsHandler(account_holder_name: txtAccountHodler.text!, account_number: txtAccountNumber.text!, ifsc: txtIFSCCode.text!, completion: {success,error in
            DispatchQueue.main.async {
                if success == true{
                 
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Success", alertMessage: "save bank details Successfully.")
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "error", alertMessage: error)
                }
            }
            
            
            })
    }
}
