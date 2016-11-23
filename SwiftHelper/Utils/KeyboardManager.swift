//
//  LCKeyboardManager.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/7/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

open class KeyboardManager: NSObject {
    /// 距离底部的间隔，默认为10
    open var bottomInterval: CGFloat = 10
    
    fileprivate var frame: CGRect!
    fileprivate var changeView: UIView!
    
    open static let shareInstance: KeyboardManager = KeyboardManager()
    
    /**
     添加监听键盘
     
     - parameter rect: 需要监听视图的frame
     - parameter view: 要改变frame的视图
     */
    open func addObserverInView(_ view: UIView, objectRect rect: CGRect) {
        removeObserver()
        addKeyboardObserver()
        self.frame = rect
        self.changeView = view
    }
    
    /**
     删除
     */
    open func removeObserver() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

}

private extension KeyboardManager {
    
   func addKeyboardObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ note:Notification){
        let telMaxY = frame.maxY
        let keyboardH : CGFloat = ((note.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height)
        let keyboardY : CGFloat = changeView.frame.size.height - keyboardH
        var duration  = (note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        if duration < 0.0 {
            duration = 0.25
        }
        UIView.animate(withDuration: duration!, animations: { () -> Void in
            if (telMaxY > keyboardY) {
                self.changeView.transform = CGAffineTransform(translationX: 0, y: keyboardY - telMaxY - self.bottomInterval)
            }else{
                self.changeView.transform = CGAffineTransform.identity
            }
        }) 
        
    }
    
    @objc func keyboardWillHide(_ note:Notification){
        let duration  = (note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: duration!, animations: { () -> Void in
            self.changeView.transform = CGAffineTransform.identity
        }) 
    }
    
}
