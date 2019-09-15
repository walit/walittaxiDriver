//
//  HistoryHandler.swift
//  Walit Driver
//
//  Created by Kavita on 16/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class HistoryHandler: NSObject {
    static let manager = HistoryHandler()
    //
    func getHistory(completion:@escaping (_ result: NSArray,_ sccess: Bool, _ error: String,_ type:NSArray,_ creditAmt:String,_ debitAmt:String)-> Void)
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
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverCashHistory")! as URL,
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
                                let credit_history =  result!["credit_history"] as? NSArray
                                let debit_history =  result!["debit_history"] as? NSArray
                               let creditAmt = result!.value(forKey: "total_credit") as! String
                                let debitAmt = result!.value(forKey: "total_debit") as! String
                            completion(credit_history!,true,"",debit_history!,creditAmt,debitAmt)
                            }else{
                                let message = array["message"] as! String
                                let reult = NSArray()
                                completion(reult,false,message,reult,"","")
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
    func getRideHistory(date:String,completion:@escaping (_ result: NSArray,_ sccess: Bool, _ error: String,_ creditAmt:String,_ debitAmt:String)-> Void)
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            "date":date
            ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverIncomeHistory")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
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
                               let rides = result?.value(forKey: "rides") as? NSArray
                                let creditAmt = result!.value(forKey: "total_rides") as! String
                                let debitAmt = result!.value(forKey: "total_earning") as! String
                                completion(rides!,true,"",creditAmt,debitAmt)
                            }else{
                                let message = array["message"] as! String
                                let reult = NSArray()
                                completion(reult,false,message,"","")
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
