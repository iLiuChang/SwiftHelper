//
//  UILabel+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by 刘畅 on 2021/1/23.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit
public extension UILabel {
    
    convenience init(font: UIFont, textColor: UIColor, text: String? = nil) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.text = text
    }

    func maxSize(width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }

    func maxHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

    func maxWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
    }
}
