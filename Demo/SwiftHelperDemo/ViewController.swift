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
        v.sh.topBorderWidth = 2
        v.sh.leftBorderWidth = 2
        v.sh.rightBorderWidth = 2
        v.sh.bottomBorderWidth = 2
        self.view.addSubview(v)
        v.frame = CGRect(x: 20, y: 100, width: 40, height: 30)
    
        v.sh.addEvent(for: .touchUpInside) { _ in
            print("touchUpInside")
        }
        v.sh.addEvent(for: .touchDown) { _ in
            print("touchDown")
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



