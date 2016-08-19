//
//  UIImage+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit
extension UIImage {
    
    /**
     * 修正图片方向
     *
     * @aImage: 一般是使用CoreGraphics获取的图片
     */
    class func fixOrientation(aImage: UIImage) -> UIImage {
        if (aImage.imageOrientation == .Up){
            return aImage
        }
        var transform = CGAffineTransformIdentity
        if aImage.imageOrientation == .Down || aImage.imageOrientation == .DownMirrored {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height)
            transform = CGAffineTransformRotate(transform,CGFloat( M_PI))
        }else if aImage.imageOrientation == .Left || aImage.imageOrientation == .LeftMirrored {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0)
            transform = CGAffineTransformRotate(transform,CGFloat(M_PI_2))
        }else if aImage.imageOrientation == .Right || aImage.imageOrientation == .RightMirrored {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height)
            transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2))
        }
        
        if aImage.imageOrientation == .UpMirrored || aImage.imageOrientation == .DownMirrored {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1)
        }else if aImage.imageOrientation == .LeftMirrored || aImage.imageOrientation == .RightMirrored {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        let ctx = CGBitmapContextCreate(nil,Int(aImage.size.width), Int(aImage.size.height),
                                        
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        
                                        CGImageGetColorSpace(aImage.CGImage),
                                        
                                        CGImageGetBitmapInfo(aImage.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        if aImage.imageOrientation == .Left || aImage.imageOrientation == .LeftMirrored || aImage.imageOrientation == .RightMirrored || aImage.imageOrientation == .Right {
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage)
        }else {
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage)
        }
        let cgimg = CGBitmapContextCreateImage(ctx)
        return UIImage(CGImage: cgimg!)
    }
    
    /**
     *  截屏
     *  @view: 要截屏的视图
     */
    class func imageWithCaptureView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    /**
     *  裁剪为圆形的图片
     */
    class func circleImageWithName(name: String) -> UIImage {
        let oldImage = UIImage(named: name)
        let imageW = oldImage?.size.width
        let imageH = oldImage?.size.height
        let circleW = imageW > imageH ? imageH : imageW
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW!, circleW!), false, 0)
        let path = UIBezierPath.init(ovalInRect: CGRectMake(0, 0, circleW!, circleW!))
        path.addClip()
        oldImage?.drawAtPoint(CGPointZero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     *  裁剪为圆形带边框的图片
     *  @border: 圆环的宽度
     */
    class func circleImageWithName(name: String, border: CGFloat, borderColor: UIColor) -> UIImage {
        let oldImage = UIImage(named: name)
        let imageW = oldImage?.size.width
        let imageH = oldImage?.size.height
        let circleW = imageW > imageH ? imageH : imageW
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW!, circleW!), false, 0)
        let path = UIBezierPath.init(ovalInRect: CGRectMake(0, 0, circleW!, circleW!))
        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        borderColor.set()
        CGContextFillPath(context)
        
        let cPath = UIBezierPath.init(ovalInRect: CGRectMake(border, border, circleW! - 2 * border, circleW! - 2 * border))
        cPath.addClip()
        oldImage?.drawAtPoint(CGPointZero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    /**
     * 裁剪图片
     */
    class func cropImageWithName(name: String, cropRect: CGRect) -> UIImage {
        let oldImage = UIImage(named: name)
        let subImageRef = CGImageCreateWithImageInRect(oldImage!.CGImage, cropRect)
        UIGraphicsBeginImageContext(cropRect.size)
        CGContextDrawImage(UIGraphicsGetCurrentContext(), cropRect, subImageRef)
        let newImage = UIImage(CGImage: subImageRef!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     *  根据颜色生成图片
     */
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     *  图片水印
     *  @point: 在图片大小范围内
     *  @atts: 属性配置，比如颜色、字体大小等
     */
    class func watermarkImageWithName(name: String, text: String, point: CGPoint, atts: [String: AnyObject]) -> UIImage {
        
        let oldImage = UIImage(named: name)
        let size = oldImage!.size
        let H = size.height
        let W = size.width
        var p = point
        if (p.x > W){
            p.x = W
        }
        if (p.x < 0){
            p.x = 0
        }
        if (p.y > H){
            p.y = H
        }
        if (p.y < 0){
            p.y = 0
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        (text as NSString).drawAtPoint(p, withAttributes: atts)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return  newImage
    }
    
   
    
}
