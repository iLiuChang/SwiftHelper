//
//  ViewController.swift
//  SwiftHelperDemo
//
//  Created by xinma on 16/8/19.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView.init(frame: CGRect(x: 20, y: 100, width: 40, height: 30))
        v.backgroundColor = UIColor.orange
        v.topBorderWidth = 2
        self.view.addSubview(v)
        
     
        2.delay {
            let alert = UIAlertController(title: "nihao", message: nil, preferredStyle: UIAlertController.Style.alert)
                .action(title: "cancel")
                .action(title: "sure") { _ in
                    print("ss")
                }
            
            self.present(alert, animated: true, completion: nil)
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



