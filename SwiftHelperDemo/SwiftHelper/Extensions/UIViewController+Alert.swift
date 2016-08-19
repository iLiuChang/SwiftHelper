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
    func showAlertController(title: String, message: String, preferredStyle: UIAlertControllerStyle = .Alert) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        self.presentViewController(alertVC, animated: true, completion: nil)
        return alertVC
    }
    
    /**
     隐藏延迟
     
     - parameter time: 时间间隔，单位：秒，默认为1.0s
     */
    func dismissAfter(time: Double = 1.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.dismiss()
        }
    }
    
    /**
     隐藏
     */
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIAlertController {
    
    /**
     添加action
     */
    func addAction(title: String, titleColor: UIColor = UIColor.blueColor(), completionHandler: (() -> Void)?) -> UIAlertController {
        
        let action = UIAlertAction(title: title, style: .Default) { (aAction) in
            if completionHandler != nil {
                completionHandler!()
            }
        }
        action.setValue(titleColor, forKey: "titleTextColor")
        self.addAction(action)
        return self
    }
   
}
