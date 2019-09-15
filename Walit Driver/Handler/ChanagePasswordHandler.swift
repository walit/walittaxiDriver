//
//  ChanagePasswordHandler.swift
//  Walit Driver
//
//  Created by Kavita on 06/04/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ChanagePasswordHandler: NSObject {
    static let manager = ChanagePasswordHandler()
    func chanagePasswordHandler(password:String,newpassword:String,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void)
    {
        Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
        
        if !Reachability.isConnectedToNetwork()
        {
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            return
        }
        let headers = [
            "access-token": Global.sharedInstance.user.access_token
            ,
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ed6a4fdd-9a1c-b350-714c-0aa629d060d3"
        ]
        let parameters = [
            "old_password": password,
            "new_password": newpassword,
            "new_confirm_password": newpassword
            ] as [String : Any]
        print(parameters)
        
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://walit.net/api/taxidriver/v1/TaxiDriverChangePassword")! as URL,
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
    func uploadImage(image:UIImage,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void){
        
        let headers = [
            "access-token": Global.sharedInstance.user.access_token
            ,
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            "postman-token": "ed6a4fdd-9a1c-b350-714c-0aa629d060d3"
        ]
        self.callMultipartApi("http://walit.net/api/taxidriver/v1/TaxiDriverImageUpload", param: [:], imageArray: [image], method: .post, header: headers as? [String : String], encodeType: .default, videoData: nil, imageNameArray: ["profile"], completion: {success,_ in
                if success == false{
                  completion(success,"fail upload image")
                }else{
                  completion(success,"successfully upload image")
                }
            
        })
    }
     func callMultipartApi(_ strApiName:String,
                                param : [String : AnyObject],
                                imageArray : [UIImage]?,
                                method: HTTPMethod,
                                header:[String : String]?,
                                encodeType:URLEncoding,
                                videoData:NSURL?,
                                imageNameArray:[String]?,completion:@escaping (_ isDisclaimer: Bool, _ error: String)-> Void){
        print("Api Name \(strApiName)")
        print("parameters \(param)")
        
        if Reachability.isConnectedToNetwork(){
            
            Miscellaneous.APPDELEGATE.window!.makeMyToastActivity()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                
                if(imageArray != nil){
                    var imgCount:Int = (imageArray?.count)!
                    for i in 0..<imgCount{
                        multipartFormData.append((imageArray?[i].jpegData(compressionQuality: 0.5))!, withName: imageNameArray![i], fileName: "profile.jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in param {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to:strApiName,headers: header)
            { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        // print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                        // print("response \(response)")
                        
                        if response.result.isSuccess {
                          
                            completion(true, "")
                        }
                        else{
                            
                            completion(false, "")
                        }
                    }
                    
                case .failure(let encodingError):
                    Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
                    
                 
                    completion(false, "")
                }
            }
            
        }else{
            Miscellaneous.APPDELEGATE.window!.stopMyToastActivity()
            Miscellaneous.APPDELEGATE.window!.showAlertFor(alertTitle: myMessages.ERROR, alertMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
        }
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
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
