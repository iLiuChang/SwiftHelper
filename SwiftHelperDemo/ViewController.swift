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
        
        let scrollview = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollview)
        scrollview.contentSize = CGSize(width: self.view.width, height: self.view.height+300)
        scrollview.addKeyboardObserver(transformView: self.view)
        
        let text = UITextField(frame: CGRect(x: 20, y: self.view.height+100, width: 100, height: 30))
        text.backgroundColor = UIColor.red
        scrollview.addSubview(text)
        
        let button = UIButton(frame: CGRect(x: 300, y: self.view.height+100, width: 100, height: 30))
        scrollview.addSubview(button)
        button.backgroundColor = UIColor(hexString: "#FCD02E")
        button.addTarget(self, action:  #selector(self.didSelectButton), for: UIControl.Event.touchUpInside)

    }
    
    @objc func didSelectButton() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



