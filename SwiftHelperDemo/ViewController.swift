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
        
        let button = SHButton(target: self, action: #selector(self.didSelectButton), font: UIFont.systemFont(ofSize: 13), titleColor: UIColor.black, title: "sure")
        button.setImage(UIImage(named: "income_gold_icon"), for: .normal)
        button.titlePosition = .left
        button.spacing = 20
        button.frame = CGRect(x: 300, y: self.view.height+100, width: 100, height: 30)
        scrollview.addSubview(button)
        button.backgroundColor = UIColor(hexString: "#FCD02E")

        let test = UITextField(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.white)
        test.frame = CGRect(x: 20, y: 300, width: 100, height: 40)
        test.backgroundColor = UIColor.red
        test.leftTextOffset = 20
        test.rightTextOffset = 20
        self.view.addSubview(test)
        
    }
    
    @objc func didSelectButton() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



