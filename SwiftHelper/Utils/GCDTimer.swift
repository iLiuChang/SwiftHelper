//
//  GCDTimer.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/11/23.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import Foundation

class GCDTimer {
    private var dispath: DispatchSource?

    init() {
    }
    
    @discardableResult
    convenience init(scheduled interval: Double,
                     queue: DispatchQueue? = nil,
                     repeats: Bool = true,
                     actionBlock: @escaping ((GCDTimer) -> ())) {
        self.init()
        let dispath = DispatchSource.makeTimerSource(queue: queue) as? DispatchSource
        dispath!.scheduleRepeating(deadline: .now(), interval: interval)
        dispath!.setEventHandler(handler: {
            actionBlock(self)
            if !repeats {
                self.dispath!.cancel()
            }
        })
        dispath!.resume()
        self.dispath = dispath
    }
    
    /**
     取消定时器
     
     - parameter aKey: 唯一标识
     */
    public func invalidate() {
        self.dispath?.cancel()
    }
}
