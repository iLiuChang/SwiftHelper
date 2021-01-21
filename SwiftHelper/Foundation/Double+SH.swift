//
//  Double+Extension.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/9/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension Double {

    func delay(_ closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}
