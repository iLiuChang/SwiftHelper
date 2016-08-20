//
//  UIImage+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    
    /**
     * 修正图片方向
     *
     * @aImage: 一般是使用CoreGraphics获取的图片
     */
    public class func fixOrientation(aImage: UIImage) -> UIImage {
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
    public class func imageWithCaptureView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    /**
     *  裁剪为圆形的图片
     */
    public class func circleImageWithName(name: String) -> UIImage {
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
    public class func circleImageWithName(name: String, border: CGFloat, borderColor: UIColor) -> UIImage {
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
    public class func cropImageWithName(name: String, cropRect: CGRect) -> UIImage {
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
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
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
    public class func watermarkImageWithName(name: String, text: String, point: CGPoint, atts: [String: AnyObject]) -> UIImage {
        
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

// MARK: - gif
public extension UIImage {
 
    public class func gifWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifWithURLString(urlString:String) -> UIImage? {
        guard let bundleURL:NSURL? = NSURL(string: urlString)
            else {
                print("SwiftGif: This image named \"\(urlString)\" does not exist")
                return nil
        }
        guard let imageData = NSData(contentsOfURL: bundleURL!) else {
            print("SwiftGif: Cannot turn image named \"\(urlString)\" into NSData")
            return nil
        }
        
        return gifWithData(imageData)
    }
    
    public class func gifWithName(name: String) -> UIImage? {
        var fileName = name
        if fileName.hasSuffix(".gif") {
            let nameRange = fileName.endIndex.advancedBy(-4) ..< fileName.endIndex
            fileName.removeRange(nameRange)
        }
        guard let bundleURL = NSBundle.mainBundle()
            .URLForResource(fileName, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(fileName)\" does not exist")
                return nil
        }
        
        guard let imageData = NSData(contentsOfURL: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(fileName)\" into NSData")
            return nil
        }
        
        return gifWithData(imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionaryRef = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                unsafeAddressOf(kCGImagePropertyGIFDictionary)),
            CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
            AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImageRef]()
        var delays = [Int]()
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(CGImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImageWithImages(frames,
                                                        duration: Double(duration) / 1000.0)
        return animation
    }
    
}
