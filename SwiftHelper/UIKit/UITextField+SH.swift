//
//  UITextField+SH.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/25.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit
public extension UITextField {
    
    convenience init(font: UIFont, textColor: UIColor, placeholder: String? = nil) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.placeholder = placeholder
    }
    
    var leftTextOffset: CGFloat {
        get {
            return self.leftView?.width ?? 0
        }
        set(offset) {
            let leftView = UIView()
            leftView.frame = CGRect(x: 0, y: 0, width: offset, height: height)
            self.leftView = leftView
            self.leftViewMode = .always
        }
    }
    
    var rightTextOffset: CGFloat {
        get {
            return self.rightView?.width ?? 0
        }
        set(offset) {
            let rightView = UIView()
            rightView.frame = CGRect(x: 0, y: 0, width: offset, height: height)
            self.rightView = rightView
            self.rightViewMode = .always
        }
    }
}
