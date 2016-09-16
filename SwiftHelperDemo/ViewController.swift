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
        
        let view = InfiniteScrollView()
        view.dataSource = self
        view.delegate = self
  
        view.frame = CGRectMake(0, 20, self.view.frame.width, 200)
        view.delegate = self
        self.view.addSubview(view)
        
        let date = NSDate() + 60
        print(date)
        iPageControl.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 20)
        view.addSubview(iPageControl)
        
        let label = AttributLabel()
        label.numberOfLines = 10
//        label.kerning = 2
        label.interlineSpacing = 10
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
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: InfiniteScrollViewDelegate, InfiniteScrollViewDataSource {
    
    var placeholderImage: UIImage {
        return UIImage()
    }

    func numberOfItemsAtInfiniteScrollView(infiniteScrollView: InfiniteScrollView) -> Int {
        return images.count
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageURLStringAtIndex index: Int) -> String? {
        return images[index]
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didSelectAtIndex index: Int) {
        print(index)
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didScrollAtIndex index: Int) {
        iPageControl.currentPage = index
    }

}


extension ViewController: HeadImagePickerViewControllerDelegate {
    func headImagePickerViewController(headPicker: HeadImagePickerViewController, didFinishPickingMediaWithImage image: UIImage) {
        iImageView.image = image
    }
}
