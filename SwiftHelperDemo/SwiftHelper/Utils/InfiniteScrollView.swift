//
//  LCInfiniteView.swift
//
//  Created by LiuChang on 16/8/13.
//

import UIKit
import Kingfisher

class InfiniteScrollView: UIView {
    
    // 当页指示器颜色
    var currentPageIndicatorTineColor: UIColor? {
        didSet {
            iPageControl.currentPageIndicatorTintColor = currentPageIndicatorTineColor
        }
    }
    
    // 每页指示器颜色
    var pageIndicatorTineColor: UIColor? {
        didSet {
            iPageControl.pageIndicatorTintColor = pageIndicatorTineColor
        }
    }
    
    // 是否显示指示器
    var pageControlHidden: Bool = false {
        didSet {
            iPageControl.hidden = pageControlHidden
        }
    }
    
    // 页码指示器的位置
    var pageControlEdgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    
    /// 定时器时间间隔，默认2.0s
    var timeInterval: Double = 2.0 {
        didSet {
            removeTimer()
            addTimer()
        }
    }
    
    // 是否开启定时器，默认开启
    var allowsTimer: Bool? {
        didSet {
            if allowsTimer == true {
                addTimer()
            }else {
                removeTimer()
            }
        }
    }
    
    // 标题字体颜色
    var titleTextColor: UIColor? {
        didSet {
            iCenterCell.titleTextColor = titleTextColor
            iReusableCell.titleTextColor = titleTextColor
        }
    }
    
    // 标题背景颜色
    var titleBackgroundColor: UIColor? {
        didSet {
            iCenterCell.titleBackgroundColor = titleBackgroundColor
            iReusableCell.titleBackgroundColor = titleBackgroundColor
        }
    }
    
    // 代理
    weak var delegate: InfiniteScrollViewDelegate?
    
    // 数据源
    weak var dataSource: InfiniteScrollViewDataSource? {
        didSet {
            iPageControl.numberOfPages = allCount()
            setupInfiniteCell(iCenterCell, currentIndex: 0)
        }
    }
    
    private lazy var iCenterCell: InfiniteCell = {
        self.iCenterCell = InfiniteCell()
        self.iCenterCell.tag = 0
        self.iCenterCell.delegate = self
        return self.iCenterCell
    }()
    
    private lazy var iReusableCell: InfiniteCell = {
        self.iReusableCell = InfiniteCell()
        self.iReusableCell.delegate = self
        return self.iReusableCell
    }()
    
    private lazy var iScrollView: UIScrollView = {
        self.iScrollView = UIScrollView()
        self.iScrollView.pagingEnabled = true
        self.iScrollView.delegate = self
        self.iScrollView.showsHorizontalScrollIndicator = false
        return self.iScrollView
    }()
    
    private lazy var iPageControl: UIPageControl = {
        self.iPageControl = UIPageControl()
        return self.iPageControl
    }()
    
    private var timer: NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iScrollView)
        iScrollView.addSubview(iCenterCell)
        self.addSubview(iPageControl)
        
        addTimer()
    }
    
    override func layoutSubviews() {
        let W = self.frame.width
        let H = self.frame.height
        iReusableCell.frame = self.bounds
        iScrollView.frame = self.bounds
        iCenterCell.frame = CGRectMake(W, 0, W, H)
        iScrollView.contentSize = CGSizeMake(W * 3.0, 0)
        iScrollView.contentOffset.x = W
        iPageControl.frame = CGRect.init(x: 0 , y: H - 20, width: W, height: 20)
        
        iPageControl.frame.origin.x += pageControlEdgeInsets.left / 2 - pageControlEdgeInsets.right / 2
        iPageControl.frame.origin.y += pageControlEdgeInsets.top / 2 - pageControlEdgeInsets.bottom / 2

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension InfiniteScrollView {
    
    func scroll() {
        let W = self.bounds.width
        if W > 0.0 {
            let offsetX = self.iScrollView.contentOffset.x + W
            iScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}



private extension InfiniteScrollView {
    
    func addTimer() {
        if (self.timer == nil) {
            self.timer =  NSTimer.scheduledTimerWithTimeInterval(self.timeInterval, target: self, selector: #selector(self.scroll), userInfo: nil, repeats: true )
        }
    }
    
    func removeTimer() {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    func configPageControl() {
        iPageControl.numberOfPages = self.allCount()
        iPageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTineColor
        iPageControl.pageIndicatorTintColor = self.pageIndicatorTineColor
        iPageControl.hidden = self.pageControlHidden
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
            iReusableCell.frame.origin.x = cW - W
            index = iCenterCell.tag + 1
            if index >= aCount { index = 0 }
        }else {
            iReusableCell.frame.origin.x = 0
            index = iCenterCell.tag - 1
            if index < 0 { index = aCount - 1 }
        }
        
        iReusableCell.tag = index
        setupInfiniteCell(iReusableCell, currentIndex: index)
        iScrollView.addSubview(iReusableCell)
        
        if offsetX >= W * 2 || offsetX <= 0 {
            let tempView = iCenterCell
            iCenterCell = iReusableCell
            iReusableCell = tempView
            
            iCenterCell.frame = iReusableCell.frame

            iScrollView.contentOffset.x = W
            iReusableCell.removeFromSuperview()
        }
        
        self.iPageControl.currentPage = iCenterCell.tag
        
    }
    
    
    func setupInfiniteCell(infiniteCell: InfiniteCell, currentIndex index: Int) {
        
        if let aDataSource = dataSource where aDataSource.respondsToSelector(#selector(InfiniteScrollViewDataSource.infiniteScrollView(_:imageAtIndex:))) {
            infiniteCell.image = aDataSource.infiniteScrollView!(self, imageAtIndex: index)
        }
        
        if let aDataSource = dataSource where aDataSource.respondsToSelector(#selector(InfiniteScrollViewDataSource.infiniteScrollView(_:titleAtIndex:))) {
            infiniteCell.title = aDataSource.infiniteScrollView!(self, titleAtIndex: index)
        }
        
        if let aDataSource = dataSource where aDataSource.respondsToSelector(#selector(InfiniteScrollViewDataSource.infiniteScrollView(_:imageURLPathAtIndex:))) {
            let path = aDataSource.infiniteScrollView!(self, imageURLPathAtIndex: index)
            var pImage: UIImage? = nil
            if aDataSource.respondsToSelector(#selector(InfiniteScrollViewDataSource.infiniteScrollView(_:placeholderImageAtIndex:))) {
                pImage = aDataSource.infiniteScrollView!(self, placeholderImageAtIndex: index)
            }
            infiniteCell.setupImageWithURLPath(path, placeholderImage: pImage)
        }
    }

}

extension InfiniteScrollView: InfiniteCellDelegate {
    
    func selectedAtInfiniteCell(infiniteCell: InfiniteCell) {
        if let aDelegate = delegate where aDelegate.respondsToSelector(#selector(InfiniteScrollViewDelegate.infiniteScrollView(_:didSelectedAtIndex:))) {
            aDelegate.infiniteScrollView!(self, didSelectedAtIndex: infiniteCell.tag)
        }

    }
}

extension InfiniteScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        changeFrame(offsetX)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if allowsTimer != false {
            self.addTimer()
        }
    }
}

class InfiniteCell: UIView {
    
    var image: UIImage? {
        didSet {
            iImageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            iLabel.text = title
        }
    }
    
    var titleTextColor: UIColor? {
        didSet {
            iLabel.textColor = titleTextColor
        }
    }
    
    var titleBackgroundColor: UIColor? {
        didSet {
            iLabel.backgroundColor = titleBackgroundColor
        }
    }
    
    weak var delegate: InfiniteCellDelegate?
    
    private lazy var iImageView: UIImageView = {
        self.iImageView = UIImageView()
        self.iImageView.userInteractionEnabled = true
        self.initTapGestureRecognizer(self.iImageView)
        return self.iImageView
    }()
    
    private lazy var iLabel: UILabel = {
        self.iLabel = UILabel()
        self.iLabel.textColor = UIColor.blackColor()
        self.iLabel.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        return self.iLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iImageView)
        iImageView.addSubview(iLabel)
        
    }
    
    override func layoutSubviews() {
        iImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        iLabel.frame = CGRect(x: 0, y: iImageView.frame.height - 30, width: iImageView.frame.width, height: 30)
        iLabel.hidden = title == nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageWithURLPath(urlPath: String, placeholderImage: UIImage?) {
        iImageView.kf_setImageWithURL(NSURL(string: urlPath), placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
}

private extension InfiniteCell {
    func initTapGestureRecognizer(view: UIView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tap)
    }
}

extension InfiniteCell {
    func tap(tapGestureRecognizer: UITapGestureRecognizer) {
        if let aDelegate = delegate  {
            aDelegate.selectedAtInfiniteCell(self)
        }
    }
}


@objc protocol InfiniteScrollViewDelegate: NSObjectProtocol {
    
    // 选中的下标
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, didSelectedAtIndex index: Int)
}

@objc protocol InfiniteScrollViewDataSource: NSObjectProtocol {
    
    // 总数
    func numberOfItemsAtInfiniteScrollView(infiniteScrollView: InfiniteScrollView) -> Int
    
    // 指定下标的标题，如果不实现该方法就不显示标题试图
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, titleAtIndex index: Int) -> String
    
    // 指定下标的图片url路径
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageURLPathAtIndex index: Int) -> String
    
    // 指定下标的图片
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, imageAtIndex index: Int) -> UIImage
    
    // 指定下标的占位图片
    optional func infiniteScrollView(infiniteScrollView: InfiniteScrollView, placeholderImageAtIndex index: Int) -> UIImage
    
}

protocol InfiniteCellDelegate: NSObjectProtocol {
    
     func selectedAtInfiniteCell(infiniteCell: InfiniteCell)
    
}
