//
//  OTPVerifyViewController.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class OTPVerifyViewController: UIViewController {

    var timer:Timer? = Timer()
    var counter = Int()
    @IBOutlet weak var btn_ResendOTP: UIButton!
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var lbl_Mobile: UILabel!
    @IBOutlet weak var imgView_Logo: UIImageView!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_Timer.alpha = 0.0
        let jeremyGif = UIImage.gifImageWithName("logo_white_gif")
        imgView_Logo.image = jeremyGif
        
        txt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txt4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbl_Mobile.text = self.username
    }
    
    func startCountDown() {
        self.counter = 59
        self.btn_ResendOTP.alpha = 0.0
        self.lbl_Timer.alpha = 1.0
       
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        counter -= 1
        lbl_Timer.text = String(format: "Your OTP will received in %d seconds", counter)
        if counter == 0 {
            timer?.invalidate()
            btn_ResendOTP.alpha = 1.0
            lbl_Timer.alpha = 0.0
        }
    }
    
    @IBAction func btnResendOTP(_ sender: Any) {
        resendOTP()
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        if txt1.text?.count == 0 || txt1.text?.count == 0 || txt1.text?.count == 0 || txt1.text?.count == 0  {
            showAlertFor(alertTitle: "Alert", alertMessage: "Please enter otp code")
        } else {
            verifyOtp()
        }
    }
    func verifyOtp(){
        let otp = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        ForgotPasswordHandler.manager.verifyPasswordHandler(username: self.username, otp: otp, completion: {success,message in
            if success == true {
                
                 DispatchQueue.main.async {
                    //Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "", alertMessage: message)
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ResetViewController") as! ResetViewController
                    vc.otp = otp
                    vc.username = self.username
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else{
                Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
            }
        })
    }
    
    func resendOTP(){
        ForgotPasswordHandler.manager.forgotPasswordHandler(username: self.username, completion: {_,_ in
            
        })
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
        //
    }
    //  Converted to Swift 5.1 by Swiftify v5.1.27756 - https://objectivec2swift.com/
  @objc  func textFieldDidChange(_ textField: UITextField?) {
        let text = textField?.text
        if text!.count >= 1 {
            if textField?.isEqual(txt1) ?? false {
                txt2.becomeFirstResponder()
            } else if textField?.isEqual(txt2) ?? false {
                txt3.becomeFirstResponder()
            } else if textField?.isEqual(txt3) ?? false {
                txt4.becomeFirstResponder()
            } else if textField?.isEqual(txt4) ?? false {
                //[self.code1 becomeFirstResponder];
                view.endEditing(true)
                startCountDown()
                verifyOtp()
            }
        }
    }
}
