//
//  NSTimer+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/7/25.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

private var  _lc_timer_cache_key = "_lc_timer_cache_key"

extension NSTimer {
    
    /**
     开启定时器
     
     - parameter aKey:        唯一标识
     - parameter interval:    间隔
     - parameter queue:       队列，为nil在主队列
     - parameter repeats:     是否重复
     - parameter actionBlock: 回调
     */
    public class func scheduledGCDTimerWithKey(aKey: String, interval: UInt64, queue: dispatch_queue_t? = nil, repeats: Bool, actionBlock: (() -> Void)) {
        var aQueue = queue
        
        if aQueue == nil { aQueue = dispatch_get_main_queue() }
        
        var timer = self.timers[aKey]
        if  timer == nil {
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
            self.timers.updateValue(timer!, forKey: aKey)
            dispatch_resume(timer!);
            dispatch_source_set_timer(timer!, dispatch_time(DISPATCH_TIME_NOW,Int64(interval) * Int64(NSEC_PER_SEC)), interval * NSEC_PER_SEC, NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer!, {
                actionBlock()
                if !repeats {
                    dispatch_source_cancel(timer!)
                }
            })
        }
        
    }
    
    /**
     取消定时器
     
     - parameter aKey: 唯一标识
     */
    public class func cancel(aKey: String) {
        if let timer = self.timers[aKey] {
            dispatch_source_cancel(timer)
            self.timers.removeValueForKey(aKey)
        }
    }
    
    /**
     取消所有通过GCD添加的定时器
     */
    public class func cancelAll() {
        for value in self.timers.values {
            dispatch_source_cancel(value)
        }
        self.timers.removeAll()
    }
}

private extension NSTimer {
    class var timers: [String: dispatch_source_t] {
        set {
            objc_setAssociatedObject(self, &_lc_timer_cache_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var caches = objc_getAssociatedObject(self, &_lc_timer_cache_key)
            if caches == nil {
                caches = [String:dispatch_source_t]()
                objc_setAssociatedObject(self, &_lc_timer_cache_key, caches, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return caches as! [String : dispatch_source_t]
        }
    }
}
