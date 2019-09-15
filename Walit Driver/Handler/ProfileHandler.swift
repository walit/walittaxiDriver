//
//  ProfileHandler.swift
//  Walit Driver
//
//  Created by Kavita on 23/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class ProfileHandler: NSObject {
    static let manager = ProfileHandler()
    func getProfileDetail(completion:@escaping (_ result: NSDictionary,_ sccess: Bool, _ error: String)-> Void)
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
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/GetDriverDetail")! as URL,
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
                          
                                completion(result ?? NSDictionary(),true,"")
                            }else{
                                let message = array["message"] as! String
                                let reult = NSDictionary()
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
