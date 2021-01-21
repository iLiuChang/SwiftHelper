//
//  Int+SH.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/21.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

extension Int {

    func delay(_ closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(self), execute: closure)
    }

    func each(_ call: (Int) -> ()) {
        for item in 0..<self {
            call(item)
        }
    }
    
    func map(_ call: (Int) -> AnyObject) -> [AnyObject] {
        var objects = [AnyObject]()
        for item in 0..<self {
            objects.append(call(item))
        }
        return objects
    }
    
    static func random(lower: Int, upper: Int) -> Int {
        let value = upper - lower + 1
        let rand = Int(arc4random_uniform(UInt32(value)))
        return lower + rand
    }
}
