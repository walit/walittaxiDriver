//
//  ResetViewController.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
    
    @IBOutlet weak var btn_ShowHidePassword: UIButton!
    @IBOutlet weak var imgView_Logo: UIImageView!
    var username = String()
    var otp = String()
    @IBOutlet weak var txtNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let jeremyGif = UIImage.gifImageWithName("logo_white_gif")
        imgView_Logo.image = jeremyGif
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_ShowHIdePassword(_ sender: Any) {
        if txtNewPassword.isSecureTextEntry{
            txtNewPassword.isSecureTextEntry = false
            btn_ShowHidePassword.setImage( UIImage(named: "icon_hide_password_green"), for: UIControl.State.normal)
            
        }else{
            btn_ShowHidePassword.setImage( UIImage(named: "baseline_remove_red_eye_black_48"), for: UIControl.State.normal)
            txtNewPassword.isSecureTextEntry = true
        }
    }
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        txtNewPassword.resignFirstResponder()
        if txtNewPassword.text?.count == 0 {
             Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter password.")
        }else{
            ForgotPasswordHandler.manager.resetPasswordHandler(username: username, otp: otp, newpassword: txtNewPassword.text!, completion: {success,message in
                if success == true {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "", alertMessage: message)
                    }
                    DispatchQueue.main.async {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
                }
            })
        }
    }
    
}
