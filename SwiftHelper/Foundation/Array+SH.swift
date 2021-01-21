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
        //通过实现get方法，获取数组中相应的值
        get {
            var result: [Element] = [self[i1], self[i2]]
            for index in rest {
                result.append(self[index])
            }
            return result
        }
        
        //通过set方法，对数组相应的索引进行设置
        set (values) {
            for (index, value) in zip([i1, i2] + rest, values) {
                self[index] = value
            }
        }
    }
    
    func each (_ call: (Element) -> ()) {
        for item in self {
            call(item)
        }
    }
    
    func each (_ call: (Int, Element) -> ()) {
        var index = 0
        for item in self {
            call(index, item)
            index += 1
        }
    }
    
    func jsonString() -> String? {
        return JSONSerialization.jsonString(from: self)
    }
    
    static func json(from jsonString: String) -> Array? {
        guard let data = JSONSerialization.jsonObject(from: jsonString) as? Array else { return nil }
        return data
    }
}
