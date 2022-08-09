//
//  String+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        
        let substring = self[index(startIndex, offsetBy: r.lowerBound)..<index(startIndex, offsetBy: r.upperBound)]
        return String(substring)
    }

    var isNumber: Bool {
        if NumberFormatter().number(from: self) != nil {
            return true
        }
        return false
    }
    
    mutating func removeLastCharacter() {
        guard self.count > 0 else {
            return
        }
        let range = self.index(self.endIndex, offsetBy: -1) ..< self.endIndex
        self = self.replacingCharacters(in: range, with: "")
    }
    
    func contains(of str: String, options: NSString.CompareOptions) -> Bool {
        return self.range(of: str, options: options) != nil
    }
    
    func contains(of str: String) -> Bool {
        return self.contains(of: str, options: .caseInsensitive)
    }
    
    func containsEmoji() -> Bool {
        for i in 0...count {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    /// Remove whitespaces and newlines
    mutating func trim() {
        self = self.trim()
    }
    
    /// Remove whitespaces and newlines
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Separation (remove whitespaces and newlines)
    func split(separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trim().isEmpty
        }
    }
    
    /// Separation (remove whitespaces and newlines)
    func split(characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trim().isEmpty
        }
    }
    
    /// Get text displayable size
    func size(for font: UIFont, size: CGSize) -> CGSize {
        let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    /// Get text displayable width
    func width(for font: UIFont) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: font.xHeight)
        return self.size(for: font, size: size).width
    }
    
    /// Get text displayable height
    func height(for font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return self.size(for: font, size: size).height
    }
}

public extension String {
    func base64Decoding() -> String? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func base64Encoded() -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
}

public extension String {
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}
