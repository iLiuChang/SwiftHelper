//
//  ImageCropViewController.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/21.
//  Copyright © 2016年 LiuChang. All rights reserved.
//
#if os(iOS)

import UIKit

open class ImageCropViewController: UIViewController {
    
    // MARK: - public properties
    
    /// 放大倍数
    open var maxScale: CGFloat = 2.0
    
    /// 半径(10 ..< SrceenWidth/2), 默认:150
    open var cropRadius: CGFloat = 150 {
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
    open var origialImage: UIImage?
    
    /// 边缘颜色
    open var cropBorderColor: UIColor = UIColor.white
    
    /// 代理
    open weak var delegate: ImageCropViewControllerDelegate?
    
    // MARK: - private properties
    
    fileprivate weak var origialImageView: UIImageView!
    fileprivate var originalFrame: CGRect!
    fileprivate var cropFrame: CGRect!
    
    // MARK: - life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
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
        imageView.frame = CGRect(x: 0, y: 0, width: fitW, height: fitH)
        imageView.isMultipleTouchEnabled = true
        imageView.isUserInteractionEnabled = true
        imageView.image = origialImage
        imageView.center = self.view.center
        imageView.backgroundColor = UIColor.black
        
        self.view.addSubview(imageView)
        self.originalFrame = imageView.frame
        origialImageView = imageView
    }
    
    func initCropView() {
        let W = self.view.frame.width
        let H = self.view.frame.height
        
        let center = self.view.center
        self.cropFrame = CGRect(x: center.x - cropRadius , y: center.y - cropRadius, width: cropRadius * 2, height: cropRadius * 2)
        
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        self.view.addSubview(view)
        let shaperLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        // top
        path.addRect(CGRect(x: 0, y: 0, width: W, height: cropFrame.origin.y))
        // down
        path.addRect(CGRect(x: 0, y: cropFrame.maxY, width: W, height: H - cropFrame.maxY))
        // left
        path.addRect( CGRect(x: 0, y: cropFrame.origin.y, width: cropFrame.origin.x, height: cropRadius * 2))
        // right
        path.addRect(CGRect(x: cropFrame.maxX, y: cropFrame.origin.y, width: W - cropFrame.maxX, height: cropRadius * 2))
        
        shaperLayer.path = path
        view.layer.mask = shaperLayer
        
        let edgePath = UIBezierPath.init(rect: cropFrame)
        let edgeLayer = CAShapeLayer()
        edgeLayer.path = edgePath.cgPath
        edgeLayer.lineWidth = 1.5
        edgeLayer.strokeColor = cropBorderColor.cgColor
        view.layer.addSublayer(edgeLayer)
    }
    
    func initButton() {
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        bottomView.backgroundColor = UIColor.black
        bottomView.alpha = 0.7
        self.view.addSubview(bottomView)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.setTitle("确定", for: UIControlState())
        button.addTarget(self, action: #selector(self.sure), for: .touchUpInside)
        bottomView.addSubview(button)
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: 50)
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
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
        let myImageRect = CGRect(x: x, y: y, width: w, height: h)
        return self.origialImage!.imageWithCropRect(myImageRect)
        
    }
    
    func handleScaleOverflow(_ lastFrame: CGRect) -> CGRect {
        
        var newFrame = lastFrame
        let oriCenter = self.origialImageView.center
        if (newFrame.size.width < self.originalFrame.size.width) {
            newFrame = self.originalFrame
        }
        var maxFrame = self.originalFrame
        maxFrame?.size.width = self.originalFrame.width * maxScale
        maxFrame?.size.height = self.originalFrame.height * maxScale
        if (newFrame.size.width > (maxFrame?.size.width)!) {
            newFrame = maxFrame!
        }
        newFrame.origin.x = oriCenter.x - (newFrame.size.width / 2)
        newFrame.origin.y = oriCenter.y - (newFrame.size.height / 2)
        return newFrame
    }
    
    func handleBorderOverflow(_ lastFrame: CGRect) -> CGRect {
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func sure() {
        delegate?.imageCropViewController?(self, didFinishCropingMediaWithImage: getSubImage())
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func pinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state == .began || pinch.state == .changed {
            origialImageView.transform = origialImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
            if self.origialImageView.frame.width > cropRadius * 2 && self.origialImageView.frame.height > cropRadius * 2 {
                self.origialImageView.frame = self.handleBorderOverflow(self.origialImageView.frame)
            }
        }else if pinch.state == .ended {
            var newFrame = handleScaleOverflow(self.origialImageView.frame)
            newFrame = handleBorderOverflow(newFrame)
            UIView.animate(withDuration: 0.25, animations: {
                self.origialImageView.frame = newFrame
            })
        }
    }
    
    func pan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began || pan.state == .changed {
            let translation = pan.translation(in: origialImageView.superview)
            origialImageView.center = CGPoint(x: origialImageView.center.x + translation.x, y: origialImageView.center.y + translation.y)
            pan.setTranslation(CGPoint.zero, in: origialImageView.superview)
        }else if pan.state == .ended {
            UIView.animate(withDuration: 0.25, animations: {
                self.origialImageView.frame = self.handleBorderOverflow(self.origialImageView.frame)
            })
        }
        
    }
}

extension UIImage {
    // crop image
    func imageWithCropRect(_ imageRect: CGRect) -> UIImage {
        let fixImage = UIImage.fixOrientation(self)
        let subImageRef = fixImage.cgImage?.cropping(to: imageRect)
        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: imageRect)
        let cropImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return cropImage
    }
    
}


@objc public protocol ImageCropViewControllerDelegate: class {
    @objc optional func imageCropViewController(_ crop: ImageCropViewController, didFinishCropingMediaWithImage image: UIImage)
}

#endif
