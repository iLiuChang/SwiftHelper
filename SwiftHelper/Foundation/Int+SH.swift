//
//  Int+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by 刘畅 on 2021/1/21.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

public extension Int {

    var abs: Int {
        return Swift.abs(self)
    }
    
    func delay(_ closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(self), execute: closure)
    }

    func each(_ body: (Int) -> ()) {
        for item in 0..<self {
            body(item)
        }
    }
    
    func map<T>(_ body: (Int) -> T) -> [T] {
        var objects = [T]()
        for item in 0..<self {
            objects.append(body(item))
        }
        return objects
    }
    
    static func random(_ r: ClosedRange<Int>) -> Int {
        let upper = r.upperBound;
        let lower = r.lowerBound;
        let value = upper - lower + 1
        let rand = Int(arc4random_uniform(UInt32(value)))
        return lower + rand
    }
}
