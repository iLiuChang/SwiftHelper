//
//  HeadImagePickerController.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//
#if os(iOS)

import UIKit

public class HeadImagePickerViewController: UIViewController {
    
    public typealias ActionConfig = (title: String?, titleColor: UIColor?)

    /// 图片放大倍数，默认2.0
    public var maxScale: CGFloat?
    /// 裁剪区域的半径，默认150
    public var cropRadius: CGFloat?
    /// 裁剪边框颜色，默认白色
    public var cropBorderColor: UIColor?
    /// 代理
    public weak var delegate: HeadImagePickerViewControllerDelegate?
    /// 默认title:相机,默认titleColor:蓝色
    public var actionCamera: ActionConfig?
    /// 默认title:相册,默认titleColor:蓝色
    public var actionPhotoLibrary: ActionConfig?
    /// 默认title:取消,默认titleColor:红色
    public var actionCancel: ActionConfig? = (nil, UIColor.redColor())
    
    private var currentAlertController: UIAlertController?

    /**
     展示
     
     - parameter superController: 父控制器
     */
    func showInController(superController: UIViewController) {
        
        superController.addChildViewController(self)
        
        let titleCamera = actionCamera?.title ?? "拍照"
        let titlePhotoLibrary = actionPhotoLibrary?.title ?? "相册"
        let titleCancel = actionCancel?.title ?? "取消"
        
        currentAlertController = superController.showAlertController(nil, titltAtt: nil, message: nil, messageAtt: nil, preferredStyle: .ActionSheet).addAction(titleCamera, titleColor: actionCamera?.titleColor) {
            
                if !self.isCamera() {
                    return
                }
                self.showPickCotrollerWithType(.Camera, toController: superController)
            
            }.addAction(titlePhotoLibrary, titleColor: actionPhotoLibrary?.titleColor) {
                
                if !self.isPhoto() {
                    return
                }
                self.showPickCotrollerWithType(.PhotoLibrary, toController: superController)
                
            }.addAction(titleCancel, titleColor: actionCancel?.titleColor) {
                self.removeController()
        }
    }
    
    /**
     删除
     */
    func dismissFromParentController() {
        currentAlertController?.dismiss()
        removeController()
    }
    
    
  
}

private extension HeadImagePickerViewController {
    
    func removeController() {
        self.removeFromParentViewController()
    }

    func showPickCotrollerWithType(type: UIImagePickerControllerSourceType, toController controller: UIViewController) {
        let pickVC = UIImagePickerController()
        pickVC.allowsEditing = false
        pickVC.delegate = self
        pickVC.sourceType = type
        controller.presentViewController(pickVC, animated: true, completion: nil)
    }
    func isPhoto() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }
    
    func isCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
}

extension HeadImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            if picker.sourceType == .Camera {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
            let vc = ImageCropViewController()
            vc.delegate = self
            vc.origialImage = image
            if let aMaxScale = self.maxScale {
                vc.maxScale = aMaxScale
            }
            if let aCropRadius = self.cropRadius {
                vc.cropRadius = aCropRadius
            }
            if let aCropBorderColor = self.cropBorderColor {
                vc.cropBorderColor = aCropBorderColor
            }
            
            if let aController = self.parentViewController {
                aController.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

}

extension HeadImagePickerViewController: ImageCropViewControllerDelegate {
    public func imageCropViewController(crop: ImageCropViewController, didFinishCropingMediaWithImage image: UIImage) {
        self.removeController()
        delegate?.headImagePickerViewController?(self, didFinishPickingMediaWithImage: image)

    }
}

@objc public protocol HeadImagePickerViewControllerDelegate: class {
    optional func headImagePickerViewController(headPicker: HeadImagePickerViewController, didFinishPickingMediaWithImage image: UIImage)
}

#endif

