//
//  UIImage+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by 刘畅 on 16/6/30.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let image = UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        guard let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// Screenshot
    convenience init(captureView: UIView) {
        UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.isOpaque, 0.0)
        captureView.drawHierarchy(in: captureView.bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: img!.cgImage!)
    }
    
    /// Crop the image
    func crop(to rect: CGRect) -> UIImage {
        guard let cgImage = cgImage,
              let imageRef = cgImage.cropping(to: rect) else { return self }
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    /// Color the image
    func tint(color: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.scaleBy(x: 1, y: -1)
            context.cgContext.translateBy(x: 0, y: -self.size.height)
            context.cgContext.clip(to: rect, mask: cgImage)
            context.cgContext.setFillColor(color.cgColor)
            context.fill(rect)
        }
    }
    
    /// return gray image
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
    
    /// Resize image
    func resize(to newSize: CGSize) -> UIImage {
        let scaledSize = newSize.applying(.init(scaleX: 1 / scale, y: 1 / scale))
        return UIGraphicsImageRenderer(size: scaledSize).image { context in
            draw(in: .init(origin: .zero, size: scaledSize))
        }
    }
    
    /// Resize image
    func resize(to newSize: CGSize, scaleMode: ImageScaleMode) -> UIImage {
        let scaledNewSize = newSize.applying(.init(scaleX: 1 / scale, y: 1 / scale))
        let aspectRatio = scaleMode.aspectRatio(between: scaledNewSize, and: size)
        
        let aspectRect = CGRect(x: (scaledNewSize.width - size.width * aspectRatio) / 2.0,
                                y: (scaledNewSize.height - size.height * aspectRatio) / 2.0,
                                width: size.width * aspectRatio,
                                height: size.height * aspectRatio)
        
        return UIGraphicsImageRenderer(size: scaledNewSize).image { context in
            draw(in: aspectRect)
        }
    }
    
    func round(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 0, borderColor: UIColor = .white) -> UIImage {
        let diameter = min(size.width, size.height)
        let isLandscape = size.width > size.height
        
        let xOffset = isLandscape ? (size.width - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (size.height - diameter) / 2
        
        let imageSize = CGSize(width: diameter, height: diameter)
        
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            let roundedPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize),
                                           cornerRadius: cornerRadius ?? diameter / 2)
            roundedPath.addClip()
            draw(at: CGPoint(x: -xOffset, y: -yOffset))
            if borderWidth > 0 {
                borderColor.setStroke()
                roundedPath.lineWidth = borderWidth
                roundedPath.stroke()
            }
        }
    }
    
    /// Pick the color on the picture(1x1 pixel)
    func pickColor(at point: CGPoint) -> UIColor? {
        guard let pixelData = self.cgImage?.dataProvider?.data else { return nil}
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerRow = 4
        let pixelInfo: Int = ((Int(size.width * scale) * Int(point.y * scale)) + Int(point.x * scale)) * bytesPerRow
        
        let red = CGFloat((data?[pixelInfo])!) / 255.0
        let green = CGFloat((data?[pixelInfo + 1])!) / 255.0
        let blue = CGFloat((data?[pixelInfo + 2])!) / 255.0
        let alpha = CGFloat((data?[pixelInfo + 3])!) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
}

extension UIImage {
    public enum ImageScaleMode {
        case aspectFill
        case aspectFit
        
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height
            
            switch self {
            case .aspectFill: return max(aspectWidth, aspectHeight)
            case .aspectFit: return min(aspectWidth, aspectHeight)
            }
        }
    }
}
