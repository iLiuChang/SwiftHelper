//
//  Double+Extension.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/9/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension Double {
    /**
     延迟
     
     - parameter closure: 结束
     */
    func delay(closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(self * Double(NSEC_PER_SEC))
            ), dispatch_get_main_queue(), closure)
    }

}