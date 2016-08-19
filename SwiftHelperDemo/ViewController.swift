//
//  ViewController.swift
//  SwiftHelperDemo
//
//  Created by xinma on 16/8/19.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfiniteScrollViewDelegate, InfiniteScrollViewDataSource {
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfItemsAtInfiniteScrollView(infiniteScrollView: InfiniteScrollView) -> Int {
        return images.count
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageURLPathAtIndex index: Int) -> String {
        return images[index]
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, placeholderImageAtIndex index: Int) -> UIImage {
        return UIImage(named: "huli.jpg")!
    }
    
    func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didSelectedAtIndex index: Int) {
        print(index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

