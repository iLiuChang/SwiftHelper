//
//  LCInfiniteView.swift
//
//  Created by LiuChang on 16/8/13.
//  无限滚动试图
#if os(iOS)

import UIKit
import Kingfisher

public class InfiniteScrollView: UIView {
    
    // MARK: - pubic properties
    
    /// 定时器时间间隔，默认2.0s
    public var timeInterval: Double = 2.0 {
        didSet {
            addTimer()
        }
    }
    
    /// 是否开启定时器，默认开启
    public var allowsTimer: Bool? {
        didSet {
            if allowsTimer == true {
                addTimer()
            }else {
                removeTimer()
            }
        }
    }
    

    /// 代理
    public weak var delegate: InfiniteScrollViewDelegate?
    
    /// 数据源
    public weak var dataSource: InfiniteScrollViewDataSource? {
        didSet {
            let num = allCount()
            if num <= 1 {
                removeTimer()
                iScrollView.scrollEnabled = false
            }
            setupImage(iCenterImageView, currentIndex: 0)
        }
    }
    
    // MARK: - private properies
    
    private lazy var iCenterImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.iCenterImageView = UIImageView()
        self.iCenterImageView.tag = 0
        self.iCenterImageView.addGestureRecognizer(tap)
        self.iCenterImageView.userInteractionEnabled = true
        return self.iCenterImageView
    }()
    
    private lazy var iReusableImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.iReusableImageView = UIImageView()
        self.iReusableImageView.addGestureRecognizer(tap)
        self.iReusableImageView.userInteractionEnabled = true
        return self.iReusableImageView
    }()
    
    private lazy var iScrollView: UIScrollView = {
        self.iScrollView = UIScrollView()
        self.iScrollView.pagingEnabled = true
        self.iScrollView.delegate = self
        self.iScrollView.showsHorizontalScrollIndicator = false
        return self.iScrollView
    }()
    
    private var timer: NSTimer?
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iScrollView)
        iScrollView.addSubview(iCenterImageView)
        addTimer()
    }
    
    override public func layoutSubviews() {
        let W = self.frame.width
        let H = self.frame.height
        iReusableImageView.frame = self.bounds
        iScrollView.frame = self.bounds
        iCenterImageView.frame = CGRectMake(W, 0, W, H)
        iScrollView.contentSize = CGSizeMake(W * 3.0, 0)
        iScrollView.contentOffset.x = W
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
    
// MARK: - reponse events
    
extension InfiniteScrollView {
    
    func scroll() {
        let W = self.bounds.width
        if W > 0.0 {
            let offsetX = self.iScrollView.contentOffset.x + W
            iScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
    
    func tap(aTap: UITapGestureRecognizer) {
        delegate?.infiniteScrollView?(self, didSelectAtIndex: aTap.view!.tag)
    }

}

// MARK: - private methods
    
private extension InfiniteScrollView {
    
    func addTimer() {
        removeTimer()
        timer =  NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(self.scroll), userInfo: nil, repeats: true )
    }
    
    func removeTimer() {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    func allCount() -> Int {
        var aCount = 0
        if dataSource != nil {
            aCount = dataSource!.numberOfItemsAtInfiniteScrollView(self)
        }
        return aCount
    }
    
    func changeFrame(offsetX: CGFloat) {
        
        let W = iScrollView.frame.width
        let cW = iScrollView.contentSize.width
        let aCount = allCount()
        var index = 0
        if offsetX > W {
            iReusableImageView.frame.origin.x = cW - W
            index = iCenterImageView.tag + 1
            if index >= aCount { index = 0 }
        }else {
            iReusableImageView.frame.origin.x = 0
            index = iCenterImageView.tag - 1
            if index < 0 { index = aCount - 1 }
        }
        
        iReusableImageView.tag = index
        setupImage(iReusableImageView, currentIndex: index)
        iScrollView.addSubview(iReusableImageView)
        
        if offsetX >= W * 2 || offsetX <= 0 {
            let tempView = iCenterImageView
            iCenterImageView = iReusableImageView
            iReusableImageView = tempView
            
            iCenterImageView.frame = iReusableImageView.frame

            iScrollView.contentOffset.x = W
            iReusableImageView.removeFromSuperview()
        }
        
        delegate?.infiniteScrollView?(self, didScrollAtIndex: iCenterImageView.tag)
        
    }
    
    
    func setupImage(imageView: UIImageView, currentIndex index: Int) {
        
        if let image = dataSource?.infiniteScrollView?(self, imageAtIndex: index) {
            imageView.image = image
        }
        
        if let urlString = dataSource?.infiniteScrollView?(self, imageURLStringAtIndex: index) {
            imageView.kf_setImageWithURL(NSURL(string: urlString), placeholderImage: dataSource?.placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
    }

}

// MARK: - UIScrollViewDelegate
    
extension InfiniteScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        changeFrame(offsetX)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if allowsTimer != false {
            self.addTimer()
        }
    }
}

// MARK: - InfiniteScrollViewDelegate

@objc public protocol InfiniteScrollViewDelegate: class {
    
    /**
     选中的下标
     */
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didSelectAtIndex index: Int)
    
    /**
     滑动的下标
     */
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didScrollAtIndex index: Int)

}

// MARK: - InfiniteScrollViewDataSource
@objc public protocol InfiniteScrollViewDataSource: class {
    
    /**
     占位图片
     */
    optional var placeholderImage: UIImage { get }
    
    /**
     总数
     */
    func numberOfItemsAtInfiniteScrollView(infiniteScrollView: InfiniteScrollView) -> Int
    
    /**
     url路径 - 网络
     */
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageURLStringAtIndex index: Int) -> String?
    
    /**
     图片 - 本地
     */
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageAtIndex index: Int) -> UIImage?
    
}


#endif
