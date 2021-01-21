//
//  UIImage+Extension.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 截屏
    convenience init(captureView: UIView) {
        UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.isOpaque, 0.0)
        captureView.drawHierarchy(in: captureView.bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: img!.cgImage!)
    }

    /// 裁剪为圆形的图片
    func circleImage() -> UIImage {
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
    
    /// 裁剪为带边框的圆形图片
    func circleImage(border: CGFloat, borderColor: UIColor) -> UIImage {
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
    
    /// 裁剪图片
    func crop(at cropRect: CGRect) -> UIImage? {
        guard let subImageRef = self.cgImage?.cropping(to: cropRect) else { return nil}
        UIGraphicsBeginImageContext(cropRect.size)
        UIGraphicsGetCurrentContext()?.draw(subImageRef, in: cropRect)
        let newImage = UIImage(cgImage: subImageRef)
        UIGraphicsEndImageContext()
        return newImage
    }
   
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func grayImage() -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray();

        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0);
        context?.draw(cgImage!, in: imageRect)

        if let imageRef = context?.makeImage() {
            let newImage = UIImage(cgImage: imageRef)
            return newImage
        }
        return nil
    }
    
    func size(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// 提取颜色 1x1 pixel
    func pickColor(at point: CGPoint) -> UIColor {
        let pixelData = self.cgImage?.dataProvider?.data
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerRow = 4
        let pixelInfo: Int = ((Int(size.width * scale) * Int(point.y * scale)) + Int(point.x * scale)) * bytesPerRow
        
        let red = CGFloat((data?[pixelInfo])!) / 255.0
        let green = CGFloat((data?[pixelInfo + 1])!) / 255.0
        let blue = CGFloat((data?[pixelInfo + 2])!) / 255.0
        let alpha = CGFloat((data?[pixelInfo + 3])!) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 修正方向
    func fixOrientation() -> UIImage? {
        guard self.cgImage != nil else {
            return nil
        }
        
        if self.imageOrientation == .up {
            return self
        }
        var transform: CGAffineTransform = .identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi) / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -(CGFloat(Double.pi) / 2))
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        
        if let ctx = CGContext(data: nil,
                               width: Int(self.size.width),
                               height: Int(self.size.height),
                               bitsPerComponent: self.cgImage!.bitsPerComponent,
                               bytesPerRow: 0,
                               space: self.cgImage!.colorSpace!,
                               bitmapInfo: self.cgImage!.bitmapInfo.rawValue) {
            
            ctx.concatenate(transform)
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            default:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }
            if let cgimg = ctx.makeImage() {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil;
    }
}
