//
//  UIView+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/7/15.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension UIView: SwiftHelperCompatible { }

public extension SwiftHelperWrapper where Base: UIView {
    var width: CGFloat {
        get { return base.frame.size.width }
        set { base.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return base.frame.size.height }
        set { base.frame.size.height = newValue }
    }
    
    var top: CGFloat {
        get { return base.frame.origin.y }
        set { base.frame.origin.y = newValue }
    }
    
    var right: CGFloat {
        get { return base.frame.maxX }
        set { base.frame.origin.x = newValue - self.width }
    }
    
    var bottom: CGFloat {
        get { return base.frame.maxY }
        set { base.frame.origin.y = newValue - self.height }
    }
    
    var left: CGFloat {
        get { return base.frame.origin.x }
        set { base.frame.origin.x = newValue }
    }
    
    var centerX: CGFloat {
        get { return base.center.x }
        set { base.center = CGPoint(x: newValue,y: self.centerY) }
    }
    
    var centerY: CGFloat {
        get { return base.center.y }
        set { base.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    var origin: CGPoint {
        set { base.frame.origin = newValue }
        get { return base.frame.origin }
    }
    
    var size: CGSize {
        set { base.frame.size = newValue }
        get { return base.frame.size }
    }
    
    var viewController: UIViewController? {
        var parentResponder: UIResponder? = base
        while let responder = parentResponder {
            parentResponder = responder.next
            if let vc = parentResponder as? UIViewController {
                return vc
            }
        }
        return nil
    }
    
    func roundedCorners(_ corners: UIRectCorner, cornerRadius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = base.bounds
        maskLayer.path = maskPath.cgPath
        base.layer.mask = maskLayer
    }
}

// MARK: - layer
private var BottomBorderViewKey: Void?
private var LeftBorderViewKey: Void?
private var TopBorderViewKey: Void?
private var RightBorderViewKey: Void?

public extension SwiftHelperWrapper where Base: UIView {

    private var borderColor: UIColor? {
        if let color = base.layer.borderColor {
            return UIColor(cgColor: color)
        }
        return nil
    }
    
    var leftBorderWidth: CGFloat {
        get {
            if let view = leftBorderView {
                return view.frame.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: base.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            base.addSubview(line)
            leftBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    var topBorderWidth: CGFloat {
        get {
            if let view = topBorderView {
                return view.frame.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: base.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.borderColor
            base.addSubview(line)
            topBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    var rightBorderWidth: CGFloat {
        get {
            if let view = rightBorderView {
                return view.frame.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: base.bounds.width, y: 0.0, width: newValue, height: base.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            base.addSubview(line)
            rightBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    var bottomBorderWidth: CGFloat {
        get {
            if let view = bottomBorderView {
                return view.frame.height
            }
            return 0.0
        }
        set {
            guard newValue >= 0 else {
                return
            }
            let line = UIView(frame: CGRect(x: 0.0, y: base.bounds.height, width: base.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            base.addSubview(line)
            bottomBorderView = line
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    private(set) var bottomBorderView: UIView? {
        get {
            return objc_getAssociatedObject(base, &BottomBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(base, &BottomBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var leftBorderView: UIView? {
        get {
            return objc_getAssociatedObject(base, &LeftBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(base, &LeftBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var topBorderView: UIView? {
        get {
            return objc_getAssociatedObject(base, &TopBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(base, &TopBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var rightBorderView: UIView? {
        get {
            return objc_getAssociatedObject(base, &RightBorderViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(base, &RightBorderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}
