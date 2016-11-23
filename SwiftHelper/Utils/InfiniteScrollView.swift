//
//  LCInfiniteView.swift
//
//  Created by LiuChang on 16/8/13.
//  无限滚动试图
#if os(iOS)

import UIKit
import Kingfisher

open class InfiniteScrollView: UIView {
    
    // MARK: - pubic properties
    
    /// 定时器时间间隔，默认3.0s
    open var timeInterval: Double = 3.0 {
        didSet {
            addTimer()
        }
    }
    
    /// 是否开启定时器，默认关闭
    open var allowsTimer = false {
        didSet {
            if allowsTimer {
                addTimer()
            }else {
                removeTimer()
            }
        }
    }
    
    /// 代理
    open weak var delegate: InfiniteScrollViewDelegate?
    
    /// 数据源
    open weak var dataSource: InfiniteScrollViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - private properies
    
    fileprivate lazy var iCenterImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.iCenterImageView = UIImageView()
        self.iCenterImageView.tag = 0
        self.iCenterImageView.addGestureRecognizer(tap)
        self.iCenterImageView.isUserInteractionEnabled = true
        return self.iCenterImageView
    }()
    
    fileprivate lazy var iReusableImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.iReusableImageView = UIImageView()
        self.iReusableImageView.addGestureRecognizer(tap)
        self.iReusableImageView.isUserInteractionEnabled = true
        return self.iReusableImageView
    }()
    
    fileprivate lazy var iScrollView: UIScrollView = {
        self.iScrollView = UIScrollView()
        self.iScrollView.isPagingEnabled = true
        self.iScrollView.delegate = self
        self.iScrollView.showsHorizontalScrollIndicator = false
        return self.iScrollView
    }()
    
    fileprivate var timer: Timer?
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iScrollView)
        iScrollView.addSubview(iCenterImageView)
    }
    
    override open func layoutSubviews() {
        let W = self.frame.width
        let H = self.frame.height
        iReusableImageView.frame = self.bounds
        iScrollView.frame = self.bounds
        iCenterImageView.frame = CGRect(x: W, y: 0, width: W, height: H)
        iScrollView.contentSize = CGSize(width: W * 3.0, height: 0)
        iScrollView.contentOffset.x = W
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeTimer()
    }
    
    /**
     刷新数据 - 自动开启定时器
     */
    open func reloadData() {
        
        let num = allCount()
        if num <= 1 {
            removeTimer()
            iScrollView.isScrollEnabled = false
        }else {
            addTimer()
            iScrollView.isScrollEnabled = true
        }
        setupImage(iCenterImageView, currentIndex: iCenterImageView.tag)
    }
    
}
    
// MARK: - reponse events
    
private extension InfiniteScrollView {
    
    @objc func scroll() {
        let W = self.bounds.width
        if W > 0.0 {
            let offsetX = W * 2
            iScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
    @objc func tap(_ aTap: UITapGestureRecognizer) {
        delegate?.infiniteScrollView?(self, didSelectAtIndex: aTap.view!.tag)
    }

}

// MARK: - private methods
    
private extension InfiniteScrollView {
    
    func addTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.scroll), userInfo: nil, repeats: true )
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
    
    func changeFrame(_ offsetX: CGFloat) {
        
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
    
    func setupImage(_ imageView: UIImageView, currentIndex index: Int) {
        if let urlString = dataSource?.infiniteScrollView?(self, imageURLStringAtIndex: index) {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: urlString)!), placeholder:  dataSource?.placeholderImage)
            return
        }

        if let image = dataSource?.infiniteScrollView?(self, imageAtIndex: index) {
            imageView.image = image
        }
    }
    
}

// MARK: - UIScrollViewDelegate
    
extension InfiniteScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        changeFrame(offsetX)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if allowsTimer {
            self.addTimer()
        }
    }
}

// MARK: - InfiniteScrollViewDelegate

@objc public protocol InfiniteScrollViewDelegate: class {
    
    /**
     选中的下标
     */
    @objc optional func infiniteScrollView(_ infiniteScrollView: InfiniteScrollView, didSelectAtIndex index: Int)
    
    /**
     滑动的下标
     */
    @objc optional func infiniteScrollView(_ infiniteScrollView: InfiniteScrollView, didScrollAtIndex index: Int)

}

// MARK: - InfiniteScrollViewDataSource
@objc public protocol InfiniteScrollViewDataSource: class {
    
    /**
     占位图片
     */
    @objc optional var placeholderImage: UIImage { get }
    
    /**
     总数
     */
    func numberOfItemsAtInfiniteScrollView(_ infiniteScrollView: InfiniteScrollView) -> Int
    
    /**
     url路径 - 网络
     */
    @objc optional func infiniteScrollView(_ infiniteScrollView: InfiniteScrollView, imageURLStringAtIndex index: Int) -> String?
    
    /**
     图片 - 本地
     */
    @objc optional func infiniteScrollView(_ infiniteScrollView: InfiniteScrollView, imageAtIndex index: Int) -> UIImage?
    
}


#endif
