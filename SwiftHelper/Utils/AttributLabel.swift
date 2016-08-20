//
//  AttributedLabel.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

#if os(iOS)

import UIKit
    
public class AttributLabel: UILabel {
    
    // 左右间距
    public var kerning: CGFloat = 0 {
        didSet {
            refreshAttributes()
        }
    }
    
    // 上下间距
    public var interlineSpacing: CGFloat = 0 {
        didSet {
            refreshAttributes()
        }
    }
    
    override public var text: String? {
        didSet {
            refreshAttributes()
        }
    }
    
    override public var font: UIFont? {
        didSet {
            refreshAttributes()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        refreshAttributes()
    }
    
    private func refreshAttributes() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSFontAttributeName] = font
        if kerning > 0 {
            attributes[NSKernAttributeName] = kerning
        }
        if interlineSpacing > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            paragraphStyle.lineSpacing = CGFloat(interlineSpacing)
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
        }
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
}
    
#endif