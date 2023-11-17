//
//  String+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension String: SwiftHelperCompatibleValue {}
public extension SwiftHelperWrapper where Base == String {
    
    subscript (safe i: Int) -> Character? {
        if (0..<base.count).contains(i) {
            return base[base.index(base.startIndex, offsetBy: i)]
        }
        return nil
    }
    
    subscript (safe i: Int) -> String? {
        if let str: Character = self[safe: i] {
            return String(str)
        }
        return nil
    }
    
    subscript (safe r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > base.count {
            return nil
        }
        
        let substring = base[base.index(base.startIndex, offsetBy: r.lowerBound)..<base.index(base.startIndex, offsetBy: r.upperBound)]
        return String(substring)
    }

    var isNumber: Bool {
        if NumberFormatter().number(from: base) != nil {
            return true
        }
        return false
    }
    
    func removeLastCharacter() -> String {
        guard base.count > 0 else {
            return base
        }
        let range = base.index(base.endIndex, offsetBy: -1) ..< base.endIndex
        return base.replacingCharacters(in: range, with: "")
    }
    
    func contains(of str: String, options: String.CompareOptions) -> Bool {
        return base.range(of: str, options: options) != nil
    }
    
    func contains(of str: String) -> Bool {
        return self.contains(of: str, options: .caseInsensitive)
    }
            
    /// Remove whitespaces and newlines
    func trim() -> String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Separation (remove whitespaces and newlines)
    func split(separator: String) -> [String] {
        return base.components(separatedBy: separator).filter {
            !$0.sh.trim().isEmpty
        }
    }
    
    /// Separation (remove whitespaces and newlines)
    func split(characters: CharacterSet) -> [String] {
        return base.components(separatedBy: characters).filter {
            !$0.sh.trim().isEmpty
        }
    }
    
    /// Get text displayable size
    func size(for font: UIFont, size: CGSize) -> CGSize {
        let boundingBox = base.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
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

public extension SwiftHelperWrapper where Base == String {
    func base64Decoding() -> String? {
        guard let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func base64Encoded() -> String? {
        guard let data = base.data(using: .utf8) else {
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
