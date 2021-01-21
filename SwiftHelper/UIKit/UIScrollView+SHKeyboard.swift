//
//  UIScrollView+SHKeyboard.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/18.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

private var UIScrollViewTransformViewKey = "UIScrollViewTransformViewKey"

public extension UIScrollView {

    func addKeyboardObserver(transformView: UIView) {
        objc_setAssociatedObject(self, &UIScrollViewTransformViewKey, transformView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (newSuperview == nil) {
            self.removeKeyboardObserver()
        }
    }

    @objc private func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let transformView = objc_getAssociatedObject(self, &UIScrollViewTransformViewKey) as? UIView else { return }
        let scrollViewRect = transformView.convert(self.frame, from: self.superview)
        if let rectValue = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let kbRect = transformView.convert(rectValue.cgRectValue, from: nil)
            let hiddenScrollViewRect = scrollViewRect.intersection(kbRect)
            if !hiddenScrollViewRect.isNull {
                var contentInsets = self.contentInset
                contentInsets.bottom = hiddenScrollViewRect.size.height
                self.contentInset = contentInsets
                self.scrollIndicatorInsets = contentInsets
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Foundation.Notification) {
        var contentInsets = self.contentInset
        contentInsets.bottom = 0
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
}
