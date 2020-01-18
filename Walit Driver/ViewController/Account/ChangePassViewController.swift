//
//  ChangePassViewController.swift
//  Walit Driver
//
//  Created by Kavita on 23/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {
 @IBOutlet weak var btnChangePassword: UIView!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
     @IBOutlet weak var txtReEnterPassword: UITextField!
   
    @IBOutlet weak var imgEye1: UIImageView!
    @IBOutlet weak var imgEye3: UIImageView!
    @IBOutlet weak var imgEye2: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnShowHide1(_ sender: Any) {
        if txtOldPassword.isSecureTextEntry{
            txtOldPassword.isSecureTextEntry = false
            imgEye1.image = UIImage(named: "icon_hide_password_green")
        }else{
            imgEye1.image = UIImage(named: "baseline_remove_red_eye_black_48")
            txtOldPassword.isSecureTextEntry = true
        }
    }
    @IBAction func btnShowHide2(_ sender: Any) {
        if txtNewPassword.isSecureTextEntry{
            txtNewPassword.isSecureTextEntry = false
            imgEye3.image = UIImage(named: "icon_hide_password_green")
        }else{
            imgEye3.image = UIImage(named: "baseline_remove_red_eye_black_48")
            txtNewPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnShowHide3(_ sender: Any) {
        if txtReEnterPassword.isSecureTextEntry{
            txtReEnterPassword.isSecureTextEntry = false
            imgEye2.image = UIImage(named: "icon_hide_password_green")
        }else{
            imgEye2.image = UIImage(named: "baseline_remove_red_eye_black_48")
            txtReEnterPassword.isSecureTextEntry = true
        }
    }
    
   
    @IBAction func btnChangePassword(_ sender: Any) {
        if txtOldPassword.text?.count == 0 {
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter old password.")
            return
        }else if txtNewPassword.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter new password.")
            return
        }else if txtReEnterPassword.text?.count == 0{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter reenter password.")
            return
        }else if txtReEnterPassword.text != txtNewPassword.text{
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Password does not match.")
            return
        }else{
            self.view.endEditing(true)
            self.changePassword()
        }
    }
    func changePassword(){
        
        ChanagePasswordHandler.manager.chanagePasswordHandler(password: txtOldPassword.text!, newpassword: txtNewPassword.text!, completion: {success,error in
            DispatchQueue.main.async {
                if success == true{
                    self.txtReEnterPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtOldPassword.text = ""
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Success", alertMessage: "Password changed Successfully.")
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Success", alertMessage: error)
                }
            }
            
        })
    }
    
}
