//
//  SideMenuViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import LGSideMenuController

class SideMenuViewController: UIViewController ,LGSideMenuDelegate{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    var arr = ["Home","Ride History","Profile","Cash History","Complain","Setting","Bank details","Privacy Policy","Terms of Use","Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData(_:)), name: NSNotification.Name(rawValue: "setData"), object: nil)
        sideMenuController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Hello")
        
    }
   
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
        self.imgUser.clipsToBounds = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
   @objc func setData(_ notification: NSNotification){
    self.lblName.text = Global.sharedInstance.user.first_name  +  " " + Global.sharedInstance.user.last_name
    self.lblMobile.text = Global.sharedInstance.user.phone
    let strImage = Global.sharedInstance.user.image
    
    let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    if let url = URL(string: myURL!) {
        self.imgUser.af_setImage(withURL: url)
    }
    else{
        self.imgUser.image = UIImage(named: "uploadUser")
    }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    @IBAction func segmentStatus(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            LoginHandler.manager.offlineOnlineStatus(status: "online")
        }else{
            LoginHandler.manager.offlineOnlineStatus(status: "offline")
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    
    
}
extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 9 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell1", for: indexPath) as! SideMenuTableViewCell
            tableView.separatorStyle = .none
            return cell
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
            
           if indexPath.row == 9{
                tableView.separatorStyle = .none
           }else{
                tableView.separatorStyle = .singleLine
            }
            cell.configureCell(index:indexPath.row)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 9{
            return 70
        }else{
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        if indexPath.row == 0 {
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HomeViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
        }else if indexPath.row == 1{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HistoryViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 2{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ProfileViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 3{
           
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "CashHistoryViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 4{
            let vc = storyboard.instantiateViewController(withIdentifier: "ComplainViewController") as! ComplainViewController
            vc.titleStr = "Help"
            navigationController.setViewControllers([vc], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
       // }else if indexPath.row == 5{
//            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ComplainViewController")], animated: false)
//            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
//            mainViewController.rootViewController = navigationController
//            mainViewController.setup(type:2)
//
//            let window = UIApplication.shared.delegate!.window!!
//            window.rootViewController = mainViewController
//
//            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 5{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SettingViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 7{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "PrivacyViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }else if indexPath.row == 6{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "BankDetailsViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)//
        }else if indexPath.row == 8{
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "T_CViewController")], animated: false)
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type:2)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)//BankDetailsViewController
        }else if indexPath.row == 9{
            let alert = UIAlertController(title: "Logout", message: "Sure you want to logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                LoginHandler.manager.logoutHandler();
                Miscellaneous.APPDELEGATE.resetDefaults()
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "LoginViewController")], animated: false)
                let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type:2)
                
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
                
                UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
                print("cancelled")
            }))
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    func willShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        DispatchQueue.main.async {
            self.lblName.text = Global.sharedInstance.user.first_name  +  " " + Global.sharedInstance.user.last_name
            self.lblMobile.text = Global.sharedInstance.user.phone
            let strImage = Global.sharedInstance.user.image
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                self.imgUser.af_setImage(withURL: url)
            }
            else{
                self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
            }
        }
    }
}
