//
//  LCKeyboardManager.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/7/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public class KeyboardManager: NSObject {
    /// 距离底部的间隔，默认为10
    public var bottomInterval: CGFloat = 10
    
    private var frame: CGRect!
    private var changeView: UIView!
    private static var keyboardManager: KeyboardManager?
    private static var onceToken: dispatch_once_t = 0
    
    public class var shareInstance: KeyboardManager {
        if keyboardManager == nil {
            dispatch_once(&onceToken) {
               keyboardManager = KeyboardManager()
            }
        }
        return keyboardManager!
    }
    
    /**
     添加监听键盘
     
     @warning: 如果在view上监听多个视图，必须在开始编辑的时候监听
     @example:
     func textFieldDidBeginEditing(textField: UITextField) {
        LCKeyboardManager.shareInstance.addKeyboardObserver(textField.frame, toView: view)
     }
     
     - parameter rect: 需要监听视图的frame
     - parameter view: 要改变frame的视图
     */
    public func addKeyboardObserver(rect: CGRect, toView view: UIView) {
        removeKeyboardObserver()
        addKeyboardObserver()
        self.frame = rect
        self.changeView = view
    }
    
    /**
     删除
     */
    public func removeKeyboardObserver() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

private extension KeyboardManager {
    
   func addKeyboardObserver() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(note:NSNotification){
        let telMaxY = CGRectGetMaxY(frame)
        let keyboardH : CGFloat = (note.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height)!
        let keyboardY : CGFloat = changeView.frame.size.height - keyboardH
        var duration  = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if duration < 0.0 {
            duration = 0.25
        }
        UIView.animateWithDuration(duration!) { () -> Void in
            if (telMaxY > keyboardY) {
                self.changeView.transform = CGAffineTransformMakeTranslation(0, keyboardY - telMaxY - self.bottomInterval)
            }else{
                self.changeView.transform = CGAffineTransformIdentity
            }
        }
        
    }
    
    @objc func keyboardWillHide(note:NSNotification){
        let duration  = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        UIView.animateWithDuration(duration!) { () -> Void in
            self.changeView.transform = CGAffineTransformIdentity
        }
    }
    
}
