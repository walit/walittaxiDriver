//
//  MRGradintView.swift
//  Walit
//
//  Created by iDev on 11/16/17.
//  Copyright © 2018 Walit. All rights reserved.
//

import UIKit

struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(width, height)
    static let minLength = min(width, height)
}

struct Device {
    static let iPhone6 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 667.0
    static let iPhone6p = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 736.0
    static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxLength == 812.0
    static func isLessThen6() -> Bool { return Screen.height < 667.0 }
}

struct Color {
    
    static var celrianBlue: UIColor {
        get { return UIColor(red: 79.0/255.0, green: 241.0/255.0, blue: 252.0/255.0, alpha: 1.0) }
    }
    
    static var ultraBlue: UIColor {
        get { return UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 249/255.0, alpha: 1.0) }
    }
    
    static var white: UIColor {
        get { return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
    }
    
    static var orange: UIColor {
        get { return UIColor(red: 253.0/255.0, green: 103.0/255.0, blue: 0.0/255.0, alpha: 1.0) }
    }
    static var lightOrange: UIColor {
        get { return UIColor(red: 254.0/255.0, green: 141.0/255.0, blue: 1.0/255.0, alpha: 1.0) }
    }
    static var green: UIColor {
        get { return UIColor(red: 25.0/255.0, green: 222.0/255.0, blue: 177.0/255.0, alpha: 1.0) }
    }
    static var gray: UIColor {
        get { return UIColor(red: 132.0/255.0, green: 132.0/255.0, blue: 132.0/255.0, alpha: 1.0) }
    }
    static var purple: UIColor {
        get { return UIColor(red: 152.0/255.0, green: 167.0/255.0, blue: 252/255.0, alpha: 1.0) }
    }
    
    static var walito: UIColor {
        get { return UIColor(red: 252.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1.0) }
    }
    static var walitlighto: UIColor {
        get { return UIColor(red: 240.0/255.0, green: 149.0/255.0, blue: 35.0/255.0, alpha: 1.0) }
    }
}

public class MRGradientView: UIView {
    let gradient = CAGradientLayer()
    enum GradientDirection:Int {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    // Programmatically: use the enum
    var direction:GradientDirection = .leftToRight
    var internalColorAlpha: CGFloat = 1.0
    
    @IBInspectable var colorAlpha: CGFloat {
        set(newValue) {
            internalColorAlpha = newValue
            setGradientLayer()
        }
        get {
            return internalColorAlpha
        }
    }
    
    // IB: use the adapter
    @IBInspectable var shapeAdapter:Int {
        get {
            return self.direction.rawValue
        }
        set( shapeIndex) {
            self.direction = GradientDirection(rawValue: shapeIndex) ?? .leftToRight
            
        }
    }
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setGradientLayer() {
        //let gradient = self.layer as! CAGradientLayer
        gradient.frame = self.bounds
        gradient.colors = [Color.walito.withAlphaComponent(internalColorAlpha).cgColor, Color.walitlighto.withAlphaComponent(internalColorAlpha).cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        }
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        if Device.iPhoneX {
            self.constraints.filter({ $0.firstAttribute == .height }).first?.constant = 84
            self.layoutIfNeeded()
        }
        gradient.frame = self.bounds
    }
    
    /* For programmatically use
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @discardableResult
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
 */
}

public class MRGradientButton: UIButton {
    
    var internalColorAlpha: CGFloat = 1.0
    enum GradientDirection:Int {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    // Programmatically: use the enum
    var direction:GradientDirection = .leftToRight
    
    let gradient = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setGradientLayer()
    }
    @IBInspectable var colorAlpha: CGFloat {
        set(newValue) {
            internalColorAlpha = newValue
            setGradientLayer()
        }
        get {
            return internalColorAlpha
        }
    }
    
    // IB: use the adapter
    @IBInspectable var shapeAdapter:Int {
        get {
            return self.direction.rawValue
        }
        set( shapeIndex) {
            self.direction = GradientDirection(rawValue: shapeIndex) ?? .leftToRight
            
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if Device.iPhoneX || Device.iPhone6 || Device.iPhone6p {
            self.constraints.filter({ $0.firstAttribute == .height }).first?.constant = 45
            self.layoutIfNeeded()
        }
        gradient.frame = self.bounds
    }
    
    private func setGradientLayer() {
        gradient.frame = self.bounds
        gradient.colors = [Color.orange.cgColor, Color.lightOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true;
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
}

