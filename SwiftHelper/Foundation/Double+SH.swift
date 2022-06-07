//
//  Double+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/9/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension Double {

    var abs: Double {
        return fabs(self)
    }
    
    func delay(_ closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}

public extension Float {

    var abs: Float {
        return fabsf(self)
    }
    
}

