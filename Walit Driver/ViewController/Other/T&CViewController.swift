//
//  T&CViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import WebKit
class T_CViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://walit.net/privacy_policy")!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
    }

}
