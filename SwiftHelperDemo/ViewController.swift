//
//  ViewController.swift
//  SwiftHelperDemo
//
//  Created by xinma on 16/8/19.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var iImageView: UIImageView = {
        self.iImageView = UIImageView()
        return self.iImageView
    }()
    
    lazy var iPageControl: UIPageControl = {
        self.iPageControl = UIPageControl()
        self.iPageControl.numberOfPages = self.images.count
        return self.iPageControl
    }()
    
    var images = ["http://p16.qhimg.com/dr/48_48_/t0125e8d438ae9d2fbb.png","http://p19.qhimg.com/dr/48_48_/t0101e2931181bb540d.png","http://p17.qhimg.com/dr/48_48_/t012d281e8ec8e27c06.png","http://p18.qhimg.com/dr/48_48_/t0184f949337481f071.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = AttributLabel()
        label.numberOfLines = 10
//        label.kerning = 2
        label.interlineSpacing = 10
        label.frame = CGRect(x: 0, y: 300, width: 100, height: 150)
        label.backgroundColor = UIColor.red
        label.text = "nihaosdfasdfasdfasdfasdfasdfasdfasdfasdfasdfaff"
        self.view.addSubview(label)
        
       iImageView.frame = CGRect(x: 50, y: 300, width: 100, height: 100)
        self.view.addSubview(iImageView)
   
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        let title = "提示"
//        let att = NSMutableAttributedString(string: title)
//        att.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 2))
//        self.showAlertController(title,titltAtt: att, message: title, messageAtt: att).dismissAfter()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



