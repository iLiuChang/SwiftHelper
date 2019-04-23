//
//  UIImage+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


extension UIImage {
    
    /**
     * 修正图片方向
     *
     * @aImage: 一般是使用CoreGraphics获取的图片
     */
    public class func fixOrientation(_ aImage: UIImage) -> UIImage {
        if (aImage.imageOrientation == .up){
            return aImage
        }
        var transform = CGAffineTransform.identity
        if aImage.imageOrientation == .down || aImage.imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat( Double.pi))
        }else if aImage.imageOrientation == .left || aImage.imageOrientation == .leftMirrored {
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        }else if aImage.imageOrientation == .right || aImage.imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: -CGFloat(Double.pi/2))
        }
        
        if aImage.imageOrientation == .upMirrored || aImage.imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: aImage.size.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
        }else if aImage.imageOrientation == .leftMirrored || aImage.imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        let ctx = CGContext(data: nil,width: Int(aImage.size.width), height: Int(aImage.size.height),
                                        
                                        bitsPerComponent: (aImage.cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                                        
                                        space: (aImage.cgImage?.colorSpace!)!,
                                        
                                        bitmapInfo: (aImage.cgImage?.bitmapInfo.rawValue)!)
        ctx?.concatenate(transform)
        if aImage.imageOrientation == .left || aImage.imageOrientation == .leftMirrored || aImage.imageOrientation == .rightMirrored || aImage.imageOrientation == .right {
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.height,height: aImage.size.width))
        }else {
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.width,height: aImage.size.height))
        }
        let cgimg = ctx?.makeImage()
        return UIImage(cgImage: cgimg!)
    }
    
    /**
     *  截屏
     *  @view: 要截屏的视图
     */
    public class func imageWithCaptureView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
    /**
     *  裁剪为圆形的图片
     */
    public func circleImage() -> UIImage {
        let imageW = self.size.width
        let imageH = self.size.height
        let circleW = imageW > imageH ? imageH : imageW
        UIGraphicsBeginImageContextWithOptions(CGSize(width: circleW, height: circleW), false, 0)
        let path = UIBezierPath.init(ovalIn: CGRect(x: 0, y: 0, width: circleW, height: circleW))
        path.addClip()
        self.draw(at: CGPoint.zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     裁剪为带边框的圆形图片
     
     - parameter border:      边框宽度
     - parameter borderColor: 边框颜色
     
     - returns: image
     */
    public func circleImage(_ border: CGFloat, borderColor: UIColor) -> UIImage {
        let imageW = self.size.width
        let imageH = self.size.height
        
        let circleW = imageW > imageH ? imageH : imageW
        let bigW = circleW + 2 * border
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bigW, height: bigW), false, 0)
        let path = UIBezierPath.init(ovalIn: CGRect(x: 0, y: 0, width: bigW, height: bigW))
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        borderColor.set()
        context?.fillPath()
        
        let cPath = UIBezierPath.init(ovalIn: CGRect(x: border, y: border, width: circleW, height: circleW))
        cPath.addClip()
        self.draw(at: CGPoint(x: border, y: border))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     * 裁剪图片
     */
    public func cropImage(_ cropRect: CGRect) -> UIImage {
        let subImageRef = self.cgImage?.cropping(to: cropRect)
        UIGraphicsBeginImageContext(cropRect.size)
        UIGraphicsGetCurrentContext()?.draw(subImageRef!, in: cropRect)
        let newImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     *  根据颜色生成图片
     */
    public class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     *  图片水印
     *  @point: 在图片大小范围内
     *  @atts: 属性配置，比如颜色、字体大小等
     */
    public func watermarkImage(_ text: String, point: CGPoint, atts: [NSAttributedString.Key : AnyObject]) -> UIImage {
        
        let size = self.size
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
        (text as NSString).draw(at: p, withAttributes: atts)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return  newImage!
    }
    
}

// MARK: - gif
extension UIImage {
 
    public class func gifWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifWithURLString(_ urlString:String) -> UIImage? {
        guard let bundleURL = URL(string: urlString) else {
            print("SwiftGif: This image named \"\(urlString)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(urlString)\" into NSData")
            return nil
        }
        
        return gifWithData(imageData)
    }
    
    public class func gifWithName(_ name: String) -> UIImage? {
        var fileName = name
        if fileName.hasSuffix(".gif") {
            let nameRange = fileName.index(fileName.endIndex, offsetBy: -4) ..< fileName.endIndex
            fileName.removeSubrange(nameRange)
        }
        guard let bundleURL = Bundle.main
            .url(forResource: fileName, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(fileName)\" does not exist")
                return nil
        }
        
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(fileName)\" into NSData")
            return nil
        }
        
        return gifWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
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
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
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
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                                        duration: Double(duration) / 1000.0)
        return animation
    }
    
}
