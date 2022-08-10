//
//  UIButton+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2021/1/25.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

/// image position
public enum UIButtonEdgeInsetsStyle: Int {
    case top, bottom, left, right
}

public extension UIButton {

    func setEdgeInsetsStyle(_ style: UIButtonEdgeInsetsStyle, imageTitleSpace space:CGFloat) {
        guard let titleLabel = self.titleLabel else { return }
        guard let imageView = self.imageView else { return }
        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        let labelWidth = titleLabel.intrinsicContentSize.width
        let labelHeight = titleLabel.intrinsicContentSize.height
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch (style) {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0)
            break
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
            break
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left:  -imageWidth, bottom: 0, right: 0)
            break
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
            break
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
   
}


