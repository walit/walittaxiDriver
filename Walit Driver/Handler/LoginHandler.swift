//
//  LoginHandler.swift
//  Walit Driver
//
//  Created by Kavita on 05/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class LoginHandler: NSObject {
    
    func savarserIDAndAccessToken() -> Void {
        
        let myLoginRecord = NSMutableDictionary()
        myLoginRecord.setObject("1", forKey: myStrings.KLOGIN as NSCopying)
        myLoginRecord.setObject(Global.getUserID(), forKey: myStrings.KUSERID as NSCopying)
        myLoginRecord.setObject(Global.getAccessToken(), forKey: myStrings.KACCESSTOKEN as NSCopying)
        myLoginRecord.setObject(Global.getUserName(), forKey: myStrings.KUSERNAME as NSCopying)
        myLoginRecord.setObject(Global.getUserImage(), forKey: myStrings.KUSERIMAGE as NSCopying)
        
        let defaults = UserDefaults.standard
        defaults.set(myLoginRecord, forKey: myStrings.KUDLOGINSTATUS)
        
    }
    static let manager = LoginHandler()
    func SignInHandler(username:String,password:String,device:String,completion:@escaping (_ user: User, _ isDisclaimer: Bool, _ error: Error?)-> Void)
    {
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "content-type": "application/json",
           
        ]
        let parameters = [
            "username": username,
            "password": password,
            "device": device
            ] as [String : Any]
        print(parameters)
        
      
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverLogin")! as URL,
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
                    if let dic  = array["data"] as? NSDictionary{
                        print(dic)
                           UserDefaults.standard.set(true, forKey: "islogin")
                           UserDefaults.standard.set(username, forKey: "username")
                           UserDefaults.standard.set(password, forKey: "password")
                       let user = User()
                       user.setData(dict: dic)
                       Global.sharedInstance.user = user
                       completion(user,true,nil)
                        self.updateFCMTOKEN()
                        
                    }else{
                        let user = User()
                        completion(user,false,nil)
                    }
                    
                }else{
                    let user = User()
                    completion(user,false,nil)
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    func updateFCMTOKEN()
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "content-type": "application/json",
            "access-token": Global.sharedInstance.user.access_token
            ,
            ]
        let parameters = [
            "fcm_token": Global.sharedInstance.FCMToken,
            
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/FcmTokenUpdate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody =  postData as? Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
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
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    func logoutHandler()
    {
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            "content-type": "application/json",
           
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverLogout")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse.debugDescription)
                
            }
        })
        
        dataTask.resume()
        
    }
    func offlineOnlineStatus(status:String)
    {
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "access-token": Global.sharedInstance.user.access_token,
            "content-type": "application/json",
            
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/SetOnlineOffline?status=\(status)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String]
        
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
                    
                }
            } catch {
                print(error)
                
            }
        })
        
        dataTask.resume()
        
    }
    //TaxiDriverLatLongUpdate
    func LatLongUpdateHandler(longitude:String,latitude:String, completion:@escaping (_ isDisclaimer: Bool, _ error: Error?)-> Void)
    {
        
        if Global.sharedInstance.user.access_token == nil {
            return
        }
        
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "content-type": "application/json",
            "access-token": Global.sharedInstance.user.access_token
            ,
            ]
        let parameters = [
            "latitude": latitude,
            "longitude": longitude,
            
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverLatLongUpdate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody =  postData as? Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
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
