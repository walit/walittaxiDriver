//
//  ComplainViewController.swift
//  Walit Driver
//
//  Created by Kavita on 09/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ComplainViewController: UIViewController {

    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtDescrption: UITextView!
    
    @IBOutlet weak var lblTitle: UILabel!
    var titleStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if titleStr == "Help"{
            self.lblTitle.text = "Help"
        }else{
            self.lblTitle.text = "Complain"
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if txtSubject.text?.count == 0 {
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter subject.")
            return
        }else if txtDescrption.text.count == 0 {
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: "Please enter descriptions.")
            return
        }else{
            self.addComplain()
        }
    }
    func addComplain(){
        ComplainHandler.manager.complainHandler(title: txtSubject.text!, description: txtSubject.text!, completion: {success,error in
            DispatchQueue.main.async {
                if success == true{
                    
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Success", alertMessage: "add complain details Successfully.")
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "error", alertMessage: error)
                }
            }
            
            
            
        })
    }
    

}
