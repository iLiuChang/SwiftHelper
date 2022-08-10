//
//  UIControl+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2022/8/2.
//  Copyright © 2022 LiuChang. All rights reserved.
//

import UIKit

private var UIControlActionHandlerKey = "UIControlActionHandlerKey"
public extension UIControl {
    
    /// add action for particular event. you can call this multiple times and you can specify multiple actions for a particular event.
    func addEvent(for controlEvents: UIControl.Event, action: @escaping (UIControl) -> Void) {
        self.addTarget(forEvent: controlEvents, handler: action)
    }
    
    /// remove the event for a set of events. pass in NULL for the action to remove all actions for that event.
    func removeEvent(for controlEvents: UIControl.Event?) {
        if let event = controlEvents {
            if let actions = objc_getAssociatedObject(self, &UIControlActionHandlerKey) as? [ActionHandler] {
                let newActions = actions.filter {
                    let isHave = $0.event != event
                    if (!isHave) {
                        self.removeTarget($0, action: #selector(ActionHandler.execute(sender:)), for: $0.event)
                    }
                    return isHave
                }
                objc_setAssociatedObject(self, &UIControlActionHandlerKey, newActions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        } else {
            if let actions = objc_getAssociatedObject(self, &UIControlActionHandlerKey) as? [ActionHandler] {
                for action in  actions{
                    self.removeTarget(action, action: #selector(ActionHandler.execute(sender:)), for: action.event)
                }
            }
            objc_setAssociatedObject(self, &UIControlActionHandlerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func addTarget(forEvent event: UIControl.Event, handler: @escaping (UIControl) -> Void) {
        let action = ActionHandler(block: handler, event: event)

        self.addTarget(action, action: #selector(ActionHandler.execute(sender:)), for: event)
        if var actions = objc_getAssociatedObject(self, &UIControlActionHandlerKey) as? [ActionHandler] {
            actions.append(action)
            objc_setAssociatedObject(self, &UIControlActionHandlerKey, actions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            var newAction = [ActionHandler]()
            newAction.append(action)
            objc_setAssociatedObject(self, &UIControlActionHandlerKey, newAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private class ActionHandler {
        var block: (UIControl) -> ()
        var event: UIControl.Event

        init(block: @escaping (UIControl) -> (), event: UIControl.Event) {
            self.block = block
            self.event = event
        }
        
        @objc dynamic func execute(sender: UIControl) {
            block(sender)
        }
    }
}

