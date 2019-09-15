//
//  SettingViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }
    @IBAction func btnChangePass(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
