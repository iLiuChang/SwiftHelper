//
//  ImageCropViewController.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/21.
//  Copyright © 2016年 LiuChang. All rights reserved.
//
#if os(iOS)

import UIKit

public class ImageCropViewController: UIViewController {
    
    // MARK: - public properties
    
    /// 放大倍数
    public var maxScale: CGFloat = 2.0
    
    /// 半径(10 ..< SrceenWidth/2), 默认:150
    public var cropRadius: CGFloat = 150 {
        didSet {
            if cropRadius > self.view.width / 2 {
                cropRadius = self.view.width / 2
            }
            if cropRadius < 10  {
                cropRadius = 10
            }
        }
    }
    
    /// 原图
    public var origialImage: UIImage?
    
    /// 边缘颜色
    public var cropBorderColor: UIColor = UIColor.whiteColor()
    
    /// 代理
    public weak var delegate: ImageCropViewControllerDelegate?
    
    // MARK: - private properties
    
    private weak var origialImageView: UIImageView!
    private var originalFrame: CGRect!
    private var cropFrame: CGRect!
    
    // MARK: - life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        initOriginalImageView()
        initCropView()
        initButton()
        initGestureRecognizer()
    }
    
}

// MARK: - private methods
    
private extension ImageCropViewController {
    func initOriginalImageView() {
        let W = origialImage!.size.width / 2
        let H = origialImage!.size.height / 2
        let SW = self.view.frame.width
        let SH = self.view.frame.height
        var fitW: CGFloat = SW
        var fitH: CGFloat = SW / W * H
        if fitH > SH {
            fitW = SH / H * W
            fitH = SH
        }
        // width
        if fitW <= fitH && fitW < cropRadius * 2 {
            let scale = fitW / (cropRadius * 2)
            fitW = cropRadius * 2
            fitH = fitH / scale
        }
        
        let imageView = UIImageView()
        imageView.frame = CGRectMake(0, 0, fitW, fitH)
        imageView.multipleTouchEnabled = true
        imageView.userInteractionEnabled = true
        imageView.image = origialImage
        imageView.center = self.view.center
        imageView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(imageView)
        self.originalFrame = imageView.frame
        origialImageView = imageView
    }
    
    func initCropView() {
        let W = self.view.frame.width
        let H = self.view.frame.height
        
        let center = self.view.center
        self.cropFrame = CGRectMake(center.x - cropRadius , center.y - cropRadius, cropRadius * 2, cropRadius * 2)
        
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.5
        self.view.addSubview(view)
        let shaperLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        
        // top
        CGPathAddRect(path, nil, CGRectMake(0, 0, W, cropFrame.origin.y))
        // down
        CGPathAddRect(path, nil, CGRectMake(0, cropFrame.maxY, W, H - cropFrame.maxY))
        // left
        CGPathAddRect(path, nil, CGRectMake(0, cropFrame.origin.y, cropFrame.origin.x, cropRadius * 2))
        // right
        CGPathAddRect(path, nil, CGRectMake(cropFrame.maxX, cropFrame.origin.y, W - cropFrame.maxX, cropRadius * 2))
        
        shaperLayer.path = path
        view.layer.mask = shaperLayer
        
        let edgePath = UIBezierPath.init(rect: cropFrame)
        let edgeLayer = CAShapeLayer()
        edgeLayer.path = edgePath.CGPath
        edgeLayer.lineWidth = 1.5
        edgeLayer.strokeColor = cropBorderColor.CGColor
        view.layer.addSublayer(edgeLayer)
    }
    
    func initButton() {
        let bottomView = UIView()
        bottomView.frame = CGRectMake(0, self.view.frame.height - 50, self.view.frame.width, 50)
        bottomView.backgroundColor = UIColor.blackColor()
        bottomView.alpha = 0.7
        self.view.addSubview(bottomView)
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 100, 50)
        button.setTitle("确定", forState: .Normal)
        button.addTarget(self, action: #selector(self.sure), forControlEvents: .TouchUpInside)
        bottomView.addSubview(button)
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRectMake(self.view.frame.width - 100, 0, 100, 50)
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.addTarget(self, action: #selector(self.cancel), forControlEvents: .TouchUpInside)
        bottomView.addSubview(cancelBtn)
    }
    
    func initGestureRecognizer() {
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(self.pinch(_:)))
        self.view.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.pan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    
    func getSubImage() -> UIImage {
        let scaleRatio = self.origialImageView.frame.size.width / self.origialImage!.size.width
        var x = (cropFrame.origin.x - self.origialImageView.frame.origin.x) / scaleRatio
        var y = (cropFrame.origin.y - self.origialImageView.frame.origin.y) / scaleRatio
        var w = cropFrame.size.width / scaleRatio
        var h = cropFrame.size.width / scaleRatio
        if (self.origialImageView.frame.size.width < cropFrame.size.width) {
            let newW = self.origialImage!.size.width
            let newH = newW * (cropFrame.size.height / cropFrame.size.width)
            x = 0
            y = y + (h - newH) / 2
            w = newH
            h = newH
        }
        if (self.origialImageView.frame.size.height < cropFrame.size.height) {
            let newH = self.origialImage!.size.height
            let newW = newH * (cropFrame.size.width / cropFrame.size.height)
            x = x + (w - newW) / 2
            y = 0
            w = newH
            h = newH
        }
        let myImageRect = CGRectMake(x, y, w, h)
        return self.origialImage!.imageWithCropRect(myImageRect)
        
    }
    
    func handleScaleOverflow(lastFrame: CGRect) -> CGRect {
        
        var newFrame = lastFrame
        let oriCenter = self.origialImageView.center
        if (newFrame.size.width < self.originalFrame.size.width) {
            newFrame = self.originalFrame
        }
        var maxFrame = self.originalFrame
        maxFrame.size.width = self.originalFrame.width * maxScale
        maxFrame.size.height = self.originalFrame.height * maxScale
        if (newFrame.size.width > maxFrame.size.width) {
            newFrame = maxFrame
        }
        newFrame.origin.x = oriCenter.x - (newFrame.size.width / 2)
        newFrame.origin.y = oriCenter.y - (newFrame.size.height / 2)
        return newFrame
    }
    
    func handleBorderOverflow(lastFrame: CGRect) -> CGRect {
        var newFrame = lastFrame
        // 水平
        if lastFrame.origin.x > cropFrame.origin.x {
            newFrame.origin.x = cropFrame.origin.x
        }
        if lastFrame.maxX < cropFrame.maxX {
            newFrame.origin.x = cropFrame.maxX - newFrame.size.width
        }
        // 垂直
        if lastFrame.origin.y > cropFrame.origin.y {
            newFrame.origin.y = cropFrame.origin.y
        }
        if lastFrame.maxY < cropFrame.maxY {
            newFrame.origin.y = cropFrame.maxY - newFrame.size.height
        }
        if self.origialImageView.frame.size.width > self.origialImageView.frame.size.height && newFrame.size.height <= cropFrame.size.height {
            newFrame.origin.y = cropFrame.origin.y + (cropFrame.size.height - newFrame.size.height) / 2
        }
        return newFrame
    }
}

// MARK: - response events
    
extension ImageCropViewController {
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sure() {
        delegate?.imageCropViewController?(self, didFinishCropingMediaWithImage: getSubImage())
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func pinch(pinch: UIPinchGestureRecognizer) {
        if pinch.state == .Began || pinch.state == .Changed {
            origialImageView.transform = CGAffineTransformScale(origialImageView.transform, pinch.scale, pinch.scale)
            pinch.scale = 1
            if self.origialImageView.frame.width > cropRadius * 2 && self.origialImageView.frame.height > cropRadius * 2 {
                self.origialImageView.frame = self.handleBorderOverflow(self.origialImageView.frame)
            }
        }else if pinch.state == .Ended {
            var newFrame = handleScaleOverflow(self.origialImageView.frame)
            newFrame = handleBorderOverflow(newFrame)
            UIView.animateWithDuration(0.25, animations: {
                self.origialImageView.frame = newFrame
            })
        }
    }
    
    func pan(pan: UIPanGestureRecognizer) {
        if pan.state == .Began || pan.state == .Changed {
            let translation = pan.translationInView(origialImageView.superview)
            origialImageView.center = CGPointMake(origialImageView.center.x + translation.x, origialImageView.center.y + translation.y)
            pan.setTranslation(CGPointZero, inView: origialImageView.superview)
        }else if pan.state == .Ended {
            UIView.animateWithDuration(0.25, animations: {
                self.origialImageView.frame = self.handleBorderOverflow(self.origialImageView.frame)
            })
        }
        
    }
}

extension UIImage {
    // crop image
    func imageWithCropRect(imageRect: CGRect) -> UIImage {
        let fixImage = UIImage.fixOrientation(self)
        let subImageRef = CGImageCreateWithImageInRect(fixImage.CGImage, imageRect)
        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, imageRect, subImageRef)
        let cropImage = UIImage(CGImage: subImageRef!)
        UIGraphicsEndImageContext()
        return cropImage
    }
    
}


@objc public protocol ImageCropViewControllerDelegate: class {
    optional func imageCropViewController(crop: ImageCropViewController, didFinishCropingMediaWithImage image: UIImage)
}

#endif