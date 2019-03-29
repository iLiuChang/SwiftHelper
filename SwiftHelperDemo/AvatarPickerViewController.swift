//
//  HeadImagePickerController.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//
#if os(iOS)

import UIKit

open class AvatarPickerViewController: UIViewController {
    
    public typealias ActionConfig = (title: String?, titleColor: UIColor?)

    /// 图片放大倍数，默认2.0
    open var maxScale: CGFloat?
    /// 裁剪区域的半径，默认150
    open var cropRadius: CGFloat?
    /// 裁剪边框颜色，默认白色
    open var cropBorderColor: UIColor?
    /// 代理
    open weak var delegate: AvatarPickerViewControllerDelegate?
    /// 默认title:相机,默认titleColor:蓝色
    open var actionCamera: ActionConfig?
    /// 默认title:相册,默认titleColor:蓝色
    open var actionPhotoLibrary: ActionConfig?
    /// 默认title:取消,默认titleColor:红色
    open var actionCancel: ActionConfig? = (nil, UIColor.red)
    
    fileprivate var currentAlertController: UIAlertController?

    /**
     展示
     
     - parameter superController: 父控制器
     */
    func showInController(_ superController: UIViewController) {
        
        superController.addChild(self)
        
        let titleCamera = actionCamera?.title ?? "拍照"
        let titlePhotoLibrary = actionPhotoLibrary?.title ?? "相册"
        let titleCancel = actionCancel?.title ?? "取消"
        
        currentAlertController = superController.showAlertController(nil, titltAtt: nil, message: nil, messageAtt: nil, preferredStyle: .actionSheet).addAction(titleCamera, titleColor: actionCamera?.titleColor) {
            
                if !self.isCamera() {
                    return
                }
                self.showPickCotrollerWithType(.camera, toController: superController)
            
            }.addAction(titlePhotoLibrary, titleColor: actionPhotoLibrary?.titleColor) {
                
                if !self.isPhoto() {
                    return
                }
                self.showPickCotrollerWithType(.photoLibrary, toController: superController)
                
            }.addAction(titleCancel, titleColor: actionCancel?.titleColor) {
                self.removeController()
        }
    }
    
    /**
     删除
     */
    func dismissFromParentController() {
        currentAlertController?.dismiss(animated: true, completion: nil)
        removeController()
    }
    
    
  
}

private extension AvatarPickerViewController {
    
    func removeController() {
        self.removeFromParent()
    }

    func showPickCotrollerWithType(_ type: UIImagePickerController.SourceType, toController controller: UIViewController) {
        let pickVC = UIImagePickerController()
        pickVC.allowsEditing = false
        pickVC.delegate = self
        pickVC.sourceType = type
        controller.present(pickVC, animated: true, completion: nil)
    }
    func isPhoto() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func isCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}

extension AvatarPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if picker.sourceType == .camera {
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
            
            if let aController = self.parent {
                aController.present(vc, animated: true, completion: nil)
            }
        }
    }

}

extension AvatarPickerViewController: ImageCropViewControllerDelegate {
    public func imageCropViewController(_ crop: ImageCropViewController, didFinishCropingMediaWithImage image: UIImage) {
        self.removeController()
        delegate?.avatarPickerViewController?(self, didFinishPickingMediaWithImage: image)

    }
}

@objc public protocol AvatarPickerViewControllerDelegate: class {
    @objc optional func avatarPickerViewController(_ picker: AvatarPickerViewController, didFinishPickingMediaWithImage image: UIImage)
}

#endif

