//
//  ViewController.swift
//  SwiftHelperDemo
//
//  Created by xinma on 16/8/19.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfiniteScrollViewDelegate, InfiniteScrollViewDataSource {
    
    lazy var iImageView: UIImageView = {
        self.iImageView = UIImageView()
        return self.iImageView
    }()
    var images: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageurls = ["http://p16.qhimg.com/dr/48_48_/t0125e8d438ae9d2fbb.png","http://p19.qhimg.com/dr/48_48_/t0101e2931181bb540d.png","http://p17.qhimg.com/dr/48_48_/t012d281e8ec8e27c06.png","http://p18.qhimg.com/dr/48_48_/t0184f949337481f071.png"]
        images = imageurls
        let view = InfiniteScrollView()
        view.dataSource = self
        view.currentPageIndicatorTineColor = UIColor.blueColor()
        view.pageIndicatorTineColor = UIColor.orangeColor()
    
        //        view.titleTextColor = UIColor.yellowColor()
        view.frame = CGRectMake(0, 20, self.view.frame.width, 200)
        view.delegate = self
        self.view.addSubview(view)
        
        let date = NSDate() + 60
        print(date)
        
        
        let label = AttributLabel()
        label.numberOfLines = 10
//        label.kerning = 2
        label.interlineSpacingValue = 10
        label.frame = CGRect(x: 0, y: 300, width: 100, height: 150)
        label.backgroundColor = UIColor.redColor()
        label.text = "nihaosdfasdfasdfasdfasdfasdfasdfasdfasdfasdfaff"
//        self.view.addSubview(label)
        
iImageView.frame = CGRect(x: 50, y: 300, width: 100, height: 100)
        self.view.addSubview(iImageView)
        
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 400, width: 50, height: 50)
        button.backgroundColor = UIColor.redColor()
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(self.click), forControlEvents: .TouchUpInside)
    }
    
    func click() {
        let vc = HeadImagePickerViewController()
        vc.delegate = self
//        vc.cropRadius = 100
        vc.actionCancel = (nil, UIColor.purpleColor())
        vc.showInController(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let title = "提示"
//        let att = NSMutableAttributedString(string: title)
//        att.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 2))
//        self.showAlertController(title,titltAtt: att, message: title, messageAtt: att).dismissAfter()
        
        
    }
    func numberOfItemsAtInfiniteScrollView(infiniteScrollView: InfiniteScrollView) -> Int {
        return images.count
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageURLStringAtIndex index: Int) -> String {
        return images[index]
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didSelectedAtIndex index: Int) {
        print(index)
    }
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ViewController: HeadImagePickerViewControllerDelegate {
    func headImagePickerViewController(headPicker: HeadImagePickerViewController, didFinishPickingMediaWithImage image: UIImage) {
        iImageView.image = image
    }
}
