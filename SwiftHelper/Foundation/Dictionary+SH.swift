//
//  Dictionary+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2021/1/18.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (key, value) -> Void in
                result[key] = value
            }
        }
        return result
    }
    
    func jsonString() -> String? {
        return JSONSerialization.jsonString(from: self)
    }
    
    static func json(from jsonString: String) -> Dictionary? {
        guard let data = JSONSerialization.jsonObject(from: jsonString) as? Dictionary else { return nil }
        return data
    }
}
