//
//  String+Extension.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension String {
    public subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: index(startIndex, offsetBy: r.lowerBound)..<index(startIndex, offsetBy: r.upperBound))
    }

    /// 字符个数
    public var length: Int {
        return self.count
    }
    
    /// 是否是手机格式
    public var isPhoneNumber: Bool {
        let pattern = "^(13[0-9]|14[5|7]|15[0-9]|17[0-9]|18[0-9])\\d{8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regextestmobile.evaluate(with: self)
    }
    
    /// 是否是邮箱格式
    public var isEmail: Bool {
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regextestmobile.evaluate(with: self)
    }
    
    /**
     改变某个范围内的字体颜色
     
     - parameter color:  颜色
     - parameter string: 要改变颜色的字符串
     
     - returns: NSAttributedString
     */
    public func attributedStrinWithColor(_ color: UIColor, rangeString string: String) -> NSAttributedString {
        let att = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: string)
        att.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        return att
    }
    
    /**
     移除最后一个字符
     */
    public mutating func removeLastCharacter() {
        guard self.length > 0 else {
            return
        }
        let range = self.index(self.endIndex, offsetBy: -1) ..< self.endIndex
        self = self.replacingCharacters(in: range, with: "")
    }
    

}
