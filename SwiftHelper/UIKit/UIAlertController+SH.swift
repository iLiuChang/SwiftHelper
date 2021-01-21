//
//  UIAlertController+SH.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/21.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

public typealias UIAlertControllerClosure = (_ buttonIndex: Int) -> Void

public extension UIAlertController {
    
    convenience init(title: String?, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, _ closure: UIAlertControllerClosure?, _ cancelButtonTitle: String?, _ otherButtonTitles: String?...) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        if let title = cancelButtonTitle {
            let cancel: UIAlertAction = UIAlertAction(title: title, style: .cancel, handler: { (action: UIAlertAction) in
                if let callBack =  closure {
                    callBack(self.getActionIndex(action))
                }
            })
            self.addAction(cancel)
        }
        for oTitle in otherButtonTitles {
            if let title = oTitle {
                let action: UIAlertAction = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
                    if let callBack =  closure {
                        callBack(self.getActionIndex(action))
                    }
                })
                self.addAction(action)
            }
        }
    }
    
    class func show(in vc: UIViewController, title: String?, message: String? = nil, delay seconds: TimeInterval = 2.0) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if (seconds > 0) {
            seconds.delay {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        alertController.show(in: vc)
    }
    
    func show(in vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
    }
    
    private func getActionIndex(_ action: UIAlertAction) -> Int {
        for i in 0..<self.actions.count {
            if action == self.actions[i] {
                return i
            }
        }
        return -1
    }
    
}
