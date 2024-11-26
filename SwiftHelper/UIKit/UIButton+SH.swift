//
//  UIButton+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2021/1/25.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

/// image position
public enum UIButtonEdgeInsetsStyle {
    case top, bottom, left, right
}

public extension UIButton {
    
    /// Adjust the position of `imageView` and `titleLabel`.
    /// - Parameters:
    ///   - style: The position of `imageView`
    ///   - space: The spacing between `imageView` and `titleLabel`.
    ///   - knownSize: Whether the size of the UIButton has been determined.
    ///   If you use automatic layout, you can set it to `false`. You don't need to set the size of UIButton,
    ///   then its size will be adjusted automatically.
    func setEdgeInsetsStyle(_ style: UIButtonEdgeInsetsStyle, imageTitleSpace space:CGFloat, knownSize:Bool = true) {
        guard let titleLabel = self.titleLabel else { return }
        guard let imageView = self.imageView else { return }
        guard let image = self.imageView?.image else { return }
        
        let imageWidth = imageView.frame.size.width > 0 ? imageView.frame.size.width : image.size.width
        let imageHeight = imageView.frame.size.height > 0 ? imageView.frame.size.height : image.size.height
        let labelWidth = titleLabel.intrinsicContentSize.width
        let labelHeight = titleLabel.intrinsicContentSize.height
        switch (style) {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space, left: 0, bottom: 0, right: -labelWidth)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space, right: 0)
            if !knownSize {
                let topOffset = ((imageHeight + labelHeight + space) - max(imageHeight,labelHeight)) / 2.0
                let leftOffset = ((imageWidth + labelWidth) - max(imageWidth,labelWidth)) / 2.0
                contentEdgeInsets = UIEdgeInsets(top: topOffset, left: -leftOffset, bottom: topOffset, right: -leftOffset)
            }
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space, right: -labelWidth)
            titleEdgeInsets = UIEdgeInsets(top: -imageHeight - space, left:  -imageWidth, bottom: 0, right: 0)
            if !knownSize {
                let topOffset = ((imageHeight + labelHeight + space) - max(imageHeight,labelHeight)) / 2.0
                let leftOffset = ((imageWidth + labelWidth) - max(imageWidth,labelWidth)) / 2.0
                contentEdgeInsets = UIEdgeInsets(top: topOffset, left: -leftOffset, bottom: topOffset, right: -leftOffset)
            }
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
            if !knownSize {
                contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: space / 2.0)
            }
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
            if !knownSize {
                contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: space / 2.0)
            }
        }
    }
   
}


