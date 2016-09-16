//
//  String+Extension.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import Foundation

extension String {
    
    /// 字符串长度
    public var length: Int {
        return self.characters.count
    }
    
    /// 是否是手机格式
    public var isPhoneFormat: Bool {
        let pattern = "^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regextestmobile.evaluateWithObject(self)
    }
    
    /// 是否是邮箱格式
    public var isEmailFormat: Bool {
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regextestmobile.evaluateWithObject(self)
    }
    
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(startIndex.advancedBy(r.startIndex)..<startIndex.advancedBy(r.endIndex)))
    }
    

}
