//
//  UIViewController+Alert.swift
//  XMTestDemo
//
//  Created by LiuChang on 16/8/13.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     显示
     */
    public func showAlertController(title: String, titltAtt: NSAttributedString? = nil, message: String, messageAtt: NSAttributedString? = nil, preferredStyle: UIAlertControllerStyle = .Alert) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let aTitleAtt = titltAtt {
            alertVC.setValue(aTitleAtt, forKey: "attributedTitle")
        }
        if let aMessageAtt = messageAtt {
            alertVC.setValue(aMessageAtt, forKey: "attributedMessage")
        }
        self.presentViewController(alertVC, animated: true, completion: nil)
        
        return alertVC
    }
    
    /**
     隐藏延迟
     
     - parameter time: 时间间隔，单位：秒，默认为1.0s
     */
    public func dismissAfter(time: Double = 1.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.dismiss()
        }
    }
    
    /**
     隐藏
     */
    public func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIAlertController {
    
    /**
     添加action
     */
    public func addAction(title: String, titleColor: UIColor? = nil, completionHandler: (() -> Void)?) -> UIAlertController {
        
        let action = UIAlertAction(title: title, style: .Default) { (aAction) in
            if completionHandler != nil {
                completionHandler!()
            }
        }
        if let aTitleColor = titleColor {
            action.setValue(aTitleColor, forKey: "titleTextColor")
        }
        self.addAction(action)
        return self
    }
   
}
