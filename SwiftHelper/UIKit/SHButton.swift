//
//  SHButton.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/26.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

open class SHButton: UIButton {
    public enum TitlePosition: Int {
        case top, bottom, left, right
    }
    
    /// The position of the title, the image is the opposite position
    public var titlePosition: TitlePosition = .right
    
    /// Space between title and image
    public var spacing: CGFloat = 0.0
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = self.titleLabel else { return }
        guard let imageView = self.imageView else { return }
        self.set(titleSize: titleLabel.size, imageRect: imageView.frame, position: titlePosition, spacing: spacing)
    }
    
    private func set(titleSize: CGSize, imageRect: CGRect, position: TitlePosition, spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        }
   }
    
}
