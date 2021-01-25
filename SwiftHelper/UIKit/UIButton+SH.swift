//
//  UIButton+SH.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/25.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

public extension UIButton {

    convenience init(target: Any?, action: Selector, font: UIFont, titleColor: UIColor, title: String? = nil) {
        self.init()
        self.setTitleColor(titleColor, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
    
    convenience init(target: Any?, action: Selector, image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
        self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
    
    convenience init(target: Any?, action: Selector, backgroundImage: UIImage) {
        self.init()
        self.setBackgroundImage(backgroundImage, for: .normal)
        self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }

}
