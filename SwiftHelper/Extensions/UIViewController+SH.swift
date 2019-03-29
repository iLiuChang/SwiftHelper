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
    public func showAlertController(_ title: String?, titltAtt: NSAttributedString? = nil, message: String?, messageAtt: NSAttributedString? = nil, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let aTitleAtt = titltAtt {
            alertVC.setValue(aTitleAtt, forKey: "attributedTitle")
        }
        if let aMessageAtt = messageAtt {
            alertVC.setValue(aMessageAtt, forKey: "attributedMessage")
        }
        self.present(alertVC, animated: true, completion: nil)
        
        return alertVC
    }
    
    /**
     隐藏延迟
     
     - parameter time: 时间间隔，单位：秒，默认为1.0s
     */
    public func dismissAfter(_ time: Double = 1.0) {
        time.delay { 
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     回到指定控制器
     
     - parameter Controller: 类控制器
     */
    func pop(to Controller: AnyClass) {
        guard let vcs = self.navigationController?.viewControllers else { return }
        for vc in vcs where vc.isKind(of: Controller) {
            _ = self.navigationController?.popToViewController(vc, animated: true)
            break
        }
    }
    
    /**
     移除
     
     - parameter Controller: 类控制器
     */
    func remove(from Controller: AnyClass) {
        guard let vcs = self.navigationController?.viewControllers else { return }
        var index: Int?
        for i in 0 ..< vcs.count {
            let vc = vcs[i]
            if vc.isKind(of: Controller) {
                index = i
                break
            }
        }
        guard let aIndex = index else { return }
        self.navigationController?.viewControllers.remove(at: aIndex)
    }
}

extension UIAlertController {
    
    /**
     添加action
     */
    public func addAction(_ title: String?, titleColor: UIColor? = nil, style: UIAlertAction.Style = .default, completionHandler: (() -> Void)?) -> UIAlertController {
        
        let action = UIAlertAction(title: title, style: style) { (aAction) in
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
