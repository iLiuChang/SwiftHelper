//
//  UIAlertController+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2021/1/21.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import UIKit

public extension UIAlertController {
    
    @discardableResult
    func action(title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    func show(in vc: UIViewController, animated: Bool = true) {
        vc.present(self, animated: animated, completion: nil)
    }
    
}

