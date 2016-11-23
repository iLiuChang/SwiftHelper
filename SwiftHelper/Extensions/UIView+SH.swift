//
//  UIView+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/7/15.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension UIView {
    
    public var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    public var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    public var right: CGFloat {
        get { return self.frame.maxX }
        set { self.frame.origin.x = newValue - self.width }
    }
    public var bottom: CGFloat {
        get { return self.frame.maxY }
        set { self.frame.origin.y = newValue - self.height }
    }
    
    public var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    public var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    
    public var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    public var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    public var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
    
    public var viewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let vc = parentResponder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}

extension UIView {
    
    public func render(at bounds: CGRect? = nil) -> UIImage {
        let bounds = bounds ?? self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0);
        drawHierarchy(in: CGRect(x: -bounds.origin.x, y: -bounds.origin.y, width: self.width , height: self.height), afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenshot!;
    }
    
}

// MARK: - layer
private var BottomBorderViewKey = "SHBottomBorderViewKey"
private var LeftBorderViewKey = "SHLeftBorderViewKey"
private var TopBorderViewKey = "SHTopBorderViewKey"
private var RightBorderViewKey = "SHBottomBorderViewKey"

extension UIView {
    
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            guard newValue >= 0 else {
                return
            }
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            guard newValue >= 0 else {
                return
            }
            layer.borderWidth = newValue
        }
    }
    
    public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    public var leftBorderWidth: CGFloat {
        get {
            if let view = leftBorderView {
                return view.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            self.addSubview(line)
            leftBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    public var topBorderWidth: CGFloat {
        get {
            if let view = topBorderView {
                return view.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            topBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    public var rightBorderWidth: CGFloat {
        get {
            if let view = rightBorderView {
                return view.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            rightBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    public var bottomBorderWidth: CGFloat {
        get {
            if let view = bottomBorderView {
                return view.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            bottomBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    public var bottomBorderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &BottomBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &BottomBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var leftBorderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &LeftBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &LeftBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var topBorderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &TopBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &TopBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var rightBorderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &RightBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &RightBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}
