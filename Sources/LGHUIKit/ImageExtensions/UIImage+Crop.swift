//
//  UIImage+Crop.swift
//  
//
//  Created by 梁光辉 on 2022/2/16.
//

import Foundation
import UIKit

typealias getRadBlock = ((_ deg: Double) -> Double)

public extension UIImage {
    // 按照指定区域裁剪图片
    func gh_crop(withRect rect: CGRect) -> UIImage {
        let rad: getRadBlock = { deg in
            return deg / 180 * Double.pi
        }
        
        var rectTransform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        
        let imageCG = self.cgImage?.cropping(to: rect.applying(rectTransform))
        if let imageCG = imageCG {
            let result = UIImage.init(cgImage: imageCG, scale: self.scale, orientation: self.imageOrientation)
            return result
        } else {
            return self
        }
    }
    
    /// 图片裁剪时，裁剪矩形的对齐方式。裁剪矩形是抽象出的一个非常小的矩形，宽高比与目标形状（一般是imageView）一致，会按照一定的规则向四周放大，目的是在原图上裁剪出一个面积最大的矩形
    @objc enum ImageCropAlignMode: Int {
        /// 上对齐裁剪。裁剪矩形保持目标形状的宽高比，往左、下、右方向按比例拉伸，直至某条边与原图对齐
        case top = 0
        /// 左对齐裁剪。往上、下、右方向按比例拉伸，直至某条边与原图对齐
        case left
        /// 下对齐裁剪。往上、左、右方向按比例拉伸，直至某条边与原图对齐
        case bottom
        /// 右对齐裁剪。往上、下、左方向按比例拉伸，直至某条边与原图对齐
        case right
        /// 左上角对齐裁剪。往下、右方向按比例拉伸，直至某条边与原图对齐
        case topLeft
        /// 右上角对齐裁剪。往左、下方向按比例拉伸，直至某条边与原图对齐
        case topRight
        /// 左下角对齐裁剪。往上、右方向按比例拉伸，直至某条边与原图对齐
        case bottomLeft
        /// 右下角对齐裁剪。往左、上方向按比例拉伸，直至某条边与原图对齐
        case bottomRight
        /// 中心对齐裁剪。往四周按比例拉伸，直至铺满 imageView
        case center
    }
    
    /// 按指定宽高比和指定裁剪区域裁剪图片。会将图片的宽高比裁剪为和 targetSize 的宽高比一致
    /// 思路是先得到 imageView，也就是 targetSize 的宽高比。然后按这个宽高比，想象一个非常小的矩形。把这个小矩形的宽和高按照某个对齐规则同时放大，保持宽高比，直至某一条边和 image 的某一条边对上
    /// 这样就在 image 上裁出了和 imageView 相同宽高比的矩形，且能够根据对齐规则确定该矩形在 image 上的位置
    /// 有些步骤是可以简化的
    @objc func gh_scaleAspectCrop(forSize targetSize: CGSize, withMode mode: ImageCropAlignMode) -> UIImage {
        if targetSize.height == 0 || targetSize.width == 0 || self.size.height == 0 || self.size.width == 0 {
            return self
        }
        
        // 图片自身宽高比
        let selfScale = self.size.width / self.size.height
        // 目标形状宽高比
        let targetScale: CGFloat = targetSize.width / targetSize.height
        
        switch mode {
        case .top:
            // 这种情况类似于把宽度减半的右上角对齐。需要重新计算一下宽度减半后的宽高比
            let newSelfScale = (self.size.width / 2) / self.size.height
            let newTargetScale = (targetSize.width / 2) / targetSize.height
            if newTargetScale < newSelfScale {
                // 底部先对齐
                let scaledWidth = self.size.height * newTargetScale * 2
                let x = (self.size.width - scaledWidth) / 2 > 0 ? (self.size.width - scaledWidth) / 2 : 0
                return gh_crop(withRect: CGRect(x: x, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                // 左右先对齐
                let scaledHeight = self.size.width / targetScale    // 这里不能用 newTargetScale
                let y = scaledHeight < self.size.height ? scaledHeight : self.size.height
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: self.size.width, height: y))
            }
        case .left:
            // 把高度减半，重新计算宽高比
            let newSelfScale = self.size.width / (self.size.height / 2)
            let newTargetScale = targetSize.width / (targetSize.height / 2)
            if newTargetScale < newSelfScale {
                // 上下先对齐
                let scaledWidth = self.size.height / 2 * newTargetScale
                let width = scaledWidth < self.size.width ? scaledWidth : self.size.width
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: width, height: self.size.height))
            } else {
                // 右边先对齐
                let scaledHeight = self.size.width / newTargetScale * 2
                let startY = (self.size.height - scaledHeight) / 2 > 0 ? (self.size.height - scaledHeight) / 2 : 0
                return gh_crop(withRect: CGRect(x: 0, y: startY, width: self.size.width, height: scaledHeight))
            }
        case .bottom:
            // 把宽度减半，重新计算宽高比
            let newSelfScale = (self.size.width / 2) / self.size.height
            let newTargetScale = (targetSize.width / 2) / targetSize.height
            if newTargetScale < newSelfScale {
                // 上边先对齐
                let scaledWidth = self.size.height * newTargetScale * 2
                let x = (self.size.width - scaledWidth) / 2 > 0 ? (self.size.width - scaledWidth) / 2 : 0
                return gh_crop(withRect: CGRect(x: x, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                // 左右先对齐
                let scaledHeight = self.size.width / targetScale
                let startY = self.size.height - scaledHeight > 0 ? self.size.height - scaledHeight : 0
                return gh_crop(withRect: CGRect(x: 0, y: startY, width: self.size.width, height: scaledHeight))
            }
        case .right:
            // 与左对齐类似。把高度减半，重新计算宽高比
            let newSelfScale = self.size.width / (self.size.height / 2)
            let newTargetScale = targetSize.width / (targetSize.height / 2)
            if newTargetScale < newSelfScale {
                // 上下先对齐
                let scaledWidth = (self.size.height / 2) * newTargetScale
                let x = self.size.width - scaledWidth > 0 ? self.size.width - scaledWidth : 0
                return gh_crop(withRect: CGRect(x: x, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                // 左边先对齐
                let scaledHeight = self.size.width / newTargetScale * 2
                let startY = (self.size.height - scaledHeight) / 2 > 0 ? (self.size.height - scaledHeight) / 2 : 0
                return gh_crop(withRect: CGRect(x: 0, y: startY, width: self.size.width, height: scaledHeight))
            }
        case .topLeft:
            if targetScale < selfScale {
                // 底部先对齐
                let scaledWidth = self.size.height * targetScale
                let width = scaledWidth < self.size.width ? scaledWidth : self.size.width
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: width, height: self.size.height))
            } else {
                // 右边先对齐
                let scaledHeight = self.size.width / targetScale
                let y = scaledHeight < self.size.height ? scaledHeight : self.size.height
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: self.size.width, height: y))
            }
        case .topRight:
            // 找到小矩形放大时，哪一条边先和图片对齐
            if targetScale < selfScale {
                // 底部先对齐
                // 小矩形完成放大后的宽度。由于宽高比一致，scaledWidth / self.size.height = targetSize.width / targetSize.height
                let scaledWidth = self.size.height * targetScale
                let x = self.size.width - scaledWidth > 0 ? self.size.width - scaledWidth : 0
                return gh_crop(withRect: CGRect(x: x, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                // 左边先对齐
                // 小矩形完成放大后的高度。由于宽高比一致，self.size.width / scaledHeight = targetSize.width / targetSize.height
                let scaledHeight = self.size.width / targetScale
                let y = scaledHeight < self.size.height ? scaledHeight : self.size.height
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: self.size.width, height: y))
            }
        case .bottomLeft:
            if targetScale < selfScale {
                // 上边先对齐
                let scaledWidth = self.size.height * targetScale
                let width = scaledWidth < self.size.width ? scaledWidth : self.size.width
                return gh_crop(withRect: CGRect(x: 0, y: 0, width: width, height: self.size.height))
            } else {
                // 右边先对齐
                let scaledHeight = self.size.width / targetScale
                let y = self.size.height - scaledHeight > 0 ? self.size.height - scaledHeight : 0
                return gh_crop(withRect: CGRect(x: 0, y: y, width: self.size.width, height: scaledHeight))
            }
        case .bottomRight:
            if targetScale < selfScale {
                // 上边先对齐
                let scaledWidth = self.size.height * targetScale
                let x = self.size.width - scaledWidth > 0 ? self.size.width - scaledWidth : 0
                return gh_crop(withRect: CGRect(x: x, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                // 左边先对齐
                let scaledHeight = self.size.width / targetScale
                let y = self.size.height - scaledHeight > 0 ? self.size.height - scaledHeight : 0
                return gh_crop(withRect: CGRect(x: 0, y: y, width: self.size.width, height: scaledHeight))
            }
        case .center:
            if targetScale < selfScale {
                // 上下先对齐
                let scaledWidth = self.size.height * targetScale
                let startX = (self.size.width - scaledWidth) / 2 > 0 ? (self.size.width - scaledWidth) / 2 : 0
                return gh_crop(withRect: CGRect(x: startX, y: 0, width: scaledWidth, height: self.size.height))
            } else {
                let scaledHeight = self.size.width / targetScale
                let startY = (self.size.height - scaledHeight) / 2 > 0 ? (self.size.height - scaledHeight) / 2 : 0
                return gh_crop(withRect: CGRect(x: 0, y: startY, width: self.size.width, height: scaledHeight))
            }
        }
    }
}



