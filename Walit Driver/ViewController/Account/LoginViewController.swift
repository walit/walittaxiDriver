//
//  LoginViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/2/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var imgEye: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jeremyGif = UIImage.gifImageWithName("walit-gif")
        imgLogo.image = jeremyGif
//        txtPassword.text = "123456"
//        txtUserName.text = "7987221189"
    }
    override func viewDidLayoutSubviews() {
          self.addGradientWithColor()
          
    }
    @IBAction func btnShowPass(_ sender: Any) {
        if txtPassword.isSecureTextEntry{
            txtPassword.isSecureTextEntry = false
            imgEye.image = UIImage(named: "icon_hide_password_green")
        }else{
            imgEye.image = UIImage(named: "baseline_remove_red_eye_black_48")
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBAction func btnForgot(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
        self.view.endEditing(true)
        if txtUserName.text?.count == 0 {
             Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter Username.")
            return
        }else if txtPassword.text?.count == 0{
             Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter password.")
            return
        }else{
            auth()
        }
    }
    func auth(){
        LoginHandler.manager.SignInHandler(username: self.txtUserName.text!,password: txtPassword.text!,device: "2"){user,success,error in
            if success == true {
                DispatchQueue.main.async {
                 
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setData"), object: nil, userInfo: nil)
                      LocationManager.manager.startLocation()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                    
                    navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HomeViewController")], animated: false)
                    
                    let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
                    mainViewController.rootViewController = navigationController
                    mainViewController.setup(type:2)
                    
                    let window = UIApplication.shared.delegate!.window!!
                    window.rootViewController = mainViewController
                    
                    UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                }
                
            }else{
                Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Invalid Username or password.")
            }
            
        }
    }
}

