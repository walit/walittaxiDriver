//
//  NavigationController.swift
//  LGSideMenuControllerDemo
//
import UIKit
class NavigationController: UINavigationController {

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        DispatchQueue.main.async {
            return UIApplication.shared.statusBarOrientation.isLandscape && UI_USER_INTERFACE_IDIOM() == .phone
        }
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return sideMenuController!.isRightViewVisible ? .slide : .fade
    }

}
