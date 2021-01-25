//
//  Array+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension Array {
    
    /// 防止数组越界
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    /// 多个索引
    /// eg: let array = [23,23,4,5,67,7] print(array[3,2,1])
    subscript(i1: Int, i2: Int, rest: Int...) -> [Element] {
        get {
            var result: [Element] = [self[i1], self[i2]]
            for index in rest {
                result.append(self[index])
            }
            return result
        }
        set (values) {
            for (index, value) in zip([i1, i2] + rest, values) {
                self[index] = value
            }
        }
    }
    
    func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                result.append(value)
            }
        }
        return result
    }
    
    func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    func forEachEnumerated(_ body: @escaping (_ index: Int, _ value: Element) -> Void) {
        enumerated().forEach(body)
    }
    
    func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }
    
    func jsonString() -> String? {
        return JSONSerialization.jsonString(from: self)
    }
    
    static func json(from jsonString: String) -> Array? {
        guard let data = JSONSerialization.jsonObject(from: jsonString) as? Array else { return nil }
        return data
    }
}

public extension Array where Element: Equatable {

    func indexes(of value: Element) -> [Int] {
        return enumerated().compactMap { ($0.element == value) ? $0.offset : nil }
    }
    
    mutating func remove(value: Element) {
        self = filter { $0 != value }
    }
}

public extension Array where Element: Hashable {
    
    mutating func remove(objects: [Element]) {
        let elementsSet = Set(objects)
        self = filter { !elementsSet.contains($0) }
    }
}

public extension Array where Element: NSObject {
    func clone() -> Array {
        var objects = Array<Element>()
        for element in self {
            objects.append(element.copy() as! Element)
        }
        return objects
    }
}
