//
//  ForgotPasswordHandler.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ForgotPasswordHandler: NSObject {
    static let manager = ForgotPasswordHandler()
    func forgotPasswordHandler(username:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ed6a4fdd-9a1c-b350-714c-0aa629d060d3"
        ]
        let parameters = [
            "username": username,
         
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverForgotPassword")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody =  postData as? Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    print(array)
                    if let  message = array["message"] as? String{
                        if message  == "Invalid Token"{
                            self.invaildToken()
                            return
                        }
                    }
                    if let status  = array["status"] as? String{
                        let message = array["message"] as? String
                        if status == "success"{
                            completion(true,message ?? "")
                        }else{
                            completion(false,message ?? "")
                        }
                        
                    }
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    func verifyPasswordHandler(username:String,otp:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ed6a4fdd-9a1c-b350-714c-0aa629d060d3"
        ]
        let parameters = [
            "username": username,
            "otp":otp
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverVerifyOtp")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody =  postData as? Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            guard let data = data else { return }
            do {
                
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    print(array)
                    if let  message = array["message"] as? String{
                        if message  == "Invalid Token"{
                            self.invaildToken()
                            return
                        }
                    }
                    if let status  = array["status"] as? String{
                        let message = array["message"] as? String
                        if status == "success"{
                            completion(true,message ?? "")
                        }else{
                            completion(false,message ?? "")
                        }
                        
                    }
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    func resetPasswordHandler(username:String,otp:String,newpassword:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ed6a4fdd-9a1c-b350-714c-0aa629d060d3"
        ]
        let parameters = [
            "username": username,
            "otp":otp,
            "new_password":newpassword
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverResetPassword")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody =  postData as? Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    print(array)
                    if let  message = array["message"] as? String{
                        if message  == "Invalid Token"{
                            self.invaildToken()
                            return
                        }
                    }
                    if let status  = array["status"] as? String{
                        let message = array["message"] as? String
                        if status == "success"{
                            completion(true,message ?? "")
                        }else{
                            completion(false,message ?? "")
                        }
                        
                    }
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    func invaildToken()
    {
        
        DispatchQueue.main.async {
            Miscellaneous.APPDELEGATE.resetDefaults()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "LoginViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
}
