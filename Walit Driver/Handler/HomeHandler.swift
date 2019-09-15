//
//  HomeHandler.swift
//  Walit Driver
//
//  Created by Kavita on 09/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class HomeHandler: NSObject {
    static let manager = HomeHandler()
    func getHomePageDetails(completion:@escaping (_ result: NSDictionary,_ sccess: Bool, _ error: String,_ type:String)-> Void)
        {
            
            if !Reachability.isConnectedToNetwork()
            {
                Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
                return
            }
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
            let headers = [
                "access-token": Global.sharedInstance.user.access_token,
            ]
            
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverHome")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers as! [String : String]
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    
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
                            if let status = array["status"] as? String{
                                if status == "success"{
                                   let  result = array["data"] as? NSDictionary
                                    let typestr =  array["type"] as? String
                                    completion(result!,true,"",typestr!)
                                }else{
                                    let message = array["message"] as! String
                                    let reult = NSDictionary()
                                    completion(reult,false,message,"")
                                }
                            }
                            
                        }
                    } catch {
                        print(error)
                        
                    }
                    
                }
            })
            
            dataTask.resume()
            
        }
    func acceptRequest(requestID:String, completion:@escaping (_ result: NSDictionary,_ isDisclaimer: Bool, _ error: String)-> Void){
    
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverAcceptRequests?request_id=\(requestID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as! [String : String]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                print(error.debugDescription)
            } else {
               
                
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
                        if let status = array["status"] as? String{
                            if status == "success"{
                                let  result = array["data"] as? NSDictionary
                                completion(result!,true,"")
                            }else{
                                let reult = NSDictionary()
                                let message = array["message"] as! String
                                completion(reult,false,message)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }
    
    func CancelRideHandler(ride_id:String,cancel_reason:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token
            ,
        ]
        let parameters = [
            "ride_id": ride_id,
            "cancel_reason": cancel_reason,
            
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverCancelRide")! as URL,
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
                        
                    }else{
                       
                        
                    }
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    
    func CancelRequest(requestID:String, completion:@escaping (_ result: Bool,_ isDisclaimer: Bool, _ error: String)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverCancelRequests?request_id=\(requestID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as! [String : String]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
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
                        if let status = array["status"] as? String{
                            if status == "success"{
                                
                            }else{
                                let message = array["message"] as! String
                                completion(false,false,message)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }

    func completeRideHandler(requestID:String, completion:@escaping (_ result: Bool,_ isDisclaimer: Bool, _ error: String)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverCompleteRide?ride_id=\(requestID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as! [String : String]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
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
                        if let status = array["status"] as? String{
                            if status == "success"{
                                completion(true,true,"")
                            }else{
                                let message = array["message"] as! String
                                completion(false,false,message)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }
    
    func VerifyOTPHandler(ride_id:String,temp_otp:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token
            ,
            ]
        let parameters = [
            "ride_id": ride_id,
            "temp_otp": temp_otp,
            
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverCustomerVerifyOtp")! as URL,
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
    
    func endRideHandler(requestID:String, completion:@escaping (_ result: Bool,_ isDisclaimer: Bool, _ error: String)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverEndRide?ride_id=\(requestID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as! [String : String]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
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
                        if let status = array["status"] as? String{
                            if status == "success"{
                                let message = array["message"] as! String
                                completion(true,true,message)
                            }else{
                                let message = array["message"] as! String
                                completion(false,false,message)
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                    
                }
                
            }
        })
        
        dataTask.resume()
    }
    func taxiDriverIncomeHandler(requestID:String, completion:@escaping (_ result: Bool, _ error: String,_ completeRide:CompleteRide)-> Void){
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token
            ,
            ]
        let parameters = [
            "ride_id": requestID,
           
            
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverIncome")! as URL,
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
                        let completeRide = CompleteRide()
                        if status == "success"{
                            
                            if let dicts = array["data"] as? NSDictionary{
                                completeRide.getData(dict:dicts)
                            }
                            
                            completion(true,message ?? "", completeRide)
                        }else{
                            completion(false,message ?? "",completeRide)
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
