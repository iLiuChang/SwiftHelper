//
//  Timer+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by 刘畅 on 2021/1/18.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

private class TimerBlock {
    var block: () -> ()
    
    init(block: @escaping () -> ()) {
        self.block = block
    }
    
    @objc dynamic func execute() {
        block()
    }
}

public extension Timer {
    
    convenience init(timeInterval: TimeInterval, repeats: Bool = true, block: @escaping () -> ()) {
        let timerBlock = TimerBlock(block: block)
        self.init(timeInterval: timeInterval, target: timerBlock, selector: #selector(TimerBlock.execute), userInfo: nil, repeats: repeats)
    }
    
    class func schedule(timeInterval: TimeInterval, repeats: Bool = true, block: @escaping () -> ()) -> Timer {
        let timer = Timer(timeInterval: timeInterval, repeats: repeats, block: block)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        return timer
    }
    
    class func scheduled(with interval: TimeInterval, repeats: Bool, handler: @escaping (Timer?) -> Void) -> Timer? {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let repeatInterval = repeats ? interval : 0
        if let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, repeatInterval, 0, 0, handler) {
            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
            return timer
        }
        return nil
    }
    
}

public extension Double {
    func every(_ block: @escaping () -> ()) -> Timer {
        return Timer.schedule(timeInterval: self, block: block)
    }
}

public extension Int {
    func every(_ block: @escaping () -> ()) -> Timer {
        return Timer.schedule(timeInterval: TimeInterval(self), block: block)
    }
}
