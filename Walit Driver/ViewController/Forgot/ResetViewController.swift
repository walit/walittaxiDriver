//
//  ResetViewController.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
    var username = String()
    var otp = String()
    @IBOutlet weak var txtNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSubmit(_ sender: Any) {
        if txtNewPassword.text?.count == 0 {
             Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter password.")
        }else{
            ForgotPasswordHandler.manager.resetPasswordHandler(username: username, otp: otp, newpassword: txtNewPassword.text!, completion: {success,message in
                if success == true {
                    
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
                }
            })
        }
    }
    
}
