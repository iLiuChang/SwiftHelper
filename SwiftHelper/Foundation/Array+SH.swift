//
//  Array+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension Array {
    
    /// return safe element
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    /// multiple index
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
    
    func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
}

public extension Array where Element: Equatable {

    func indexes(of value: Element) -> [Int] {
        return enumerated().compactMap { ($0.element == value) ? $0.offset : nil }
    }
    
    mutating func remove(value: Element) {
        self = filter { $0 != value }
    }
    
    mutating func remove(first value: Element) {
        guard let index = firstIndex(of: value) else { return }
        remove(at: index)
    }
    
    mutating func remove(last value: Element) {
        guard let index = lastIndex(of: value) else { return }
        remove(at: index)
    }
}

public extension Array where Element: Hashable {
    
    mutating func remove(objects: [Element]) {
        let elementsSet = Set(objects)
        self = filter { !elementsSet.contains($0) }
    }
    
    mutating func unique() {
        self = reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}

extension Array: SwiftHelperCompatibleValue {}

public extension SwiftHelperWrapper where Base == Array<NSObject> {
    func clone() -> Base {
        var objects = Base()
        for element in base {
            objects.append(element.copy() as! NSObject)
        }
        return objects
    }
}

