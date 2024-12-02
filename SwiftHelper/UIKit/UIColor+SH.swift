//
//  UIColor+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension UIColor {
    
    enum AlphaPosition {
        case prefix
        case suffix
    }
    
    convenience init(hexString: String, alphaPosition: AlphaPosition = .prefix) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex = hexString.uppercased()
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }else if hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        }
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                switch alphaPosition {
                case .prefix:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    break
                case .suffix:
                    alpha = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    red   = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    green = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    blue  = CGFloat(hexValue & 0x000F)             / 15.0
                    break
                }
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                switch alphaPosition {
                case .prefix:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    break
                case .suffix:
                    alpha = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    red   = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x000000FF)         / 255.0
                    break
                }
            default:
                print("Invalid RGB string")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    convenience init(rgbValue: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
