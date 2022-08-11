//
//  ViewController.swift
//  SwiftHelperDemo
//
//  Created by SwiftHelper on 16/8/19.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIButton.init()
        v.backgroundColor = UIColor.orange
        v.topBorderWidth = 2
        v.leftBorderWidth = 2
        v.rightBorderWidth = 2
        v.bottomBorderWidth = 2
        self.view.addSubview(v)
        v.frame = CGRect(x: 20, y: 100, width: 40, height: 30)
    
        v.addEvent(for: .touchUpInside) { _ in
            print("touchUpInside")
        }
        v.addEvent(for: .touchDown) { _ in
            print("touchDown")
        }
        2.delay {
            UIAlertController(title: "remove event", message: nil, preferredStyle: UIAlertController.Style.alert)
                .action(title: "cancel")
                .action(title: "sure") { _ in
                    v.removeEvent(for: .touchUpInside)
                }
                .show(in: self)
        }
    }
    
    @objc func didSelectButton() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



