//
//  IntroViewController.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/25/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
  
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
       // print(keychain.get("device_uuid")!)
        
        let jeremyGif = UIImage.gifImageWithName("ezgif.com-gif-maker (2)")
        img.image = jeremyGif
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if (UserDefaults.standard.value(forKey: "islogin") as? Bool) != nil{
                let username = UserDefaults.standard.value(forKey: "username") as? String
                let password = UserDefaults.standard.value(forKey: "password") as? String
                LoginHandler.manager.SignInHandler(username: username ?? "",password: password ?? "",device: "2"){user,success,error in
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
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                       
                    }
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
            }
        }
}

