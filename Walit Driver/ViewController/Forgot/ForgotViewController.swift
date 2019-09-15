//
//  ForgotViewController.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var txtMobile: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGetOTP(_ sender: Any) {
        if txtMobile.text?.count == 0 {
             Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter Username/Mobile.")
        }else{
            self.getOTP()
        }
    }
    func getOTP(){
        ForgotPasswordHandler.manager.forgotPasswordHandler(username: txtMobile.text!, completion: {_,_ in
            DispatchQueue.main.async {
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyViewController") as! OTPVerifyViewController
                vc.username = self.txtMobile.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
}
