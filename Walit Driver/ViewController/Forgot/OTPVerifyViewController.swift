//
//  OTPVerifyViewController.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class OTPVerifyViewController: UIViewController {

    
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnResendOTP(_ sender: Any) {
        
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        
    }
    func verifyOtp(){
        let otp = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        ForgotPasswordHandler.manager.verifyPasswordHandler(username: self.username, otp: otp, completion: {success,message in
            if success == true {
                
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ResetViewController
                vc.otp = otp
                vc.username = self.username
                self.navigationController?.pushViewController(vc, animated: true)
                   Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
            }else{
                Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
            }
        })
    }
}
