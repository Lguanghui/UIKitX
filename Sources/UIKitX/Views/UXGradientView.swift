//
//  UXGradientView.swift
//  UIKitX
//
//  Created by 梁光辉 on 2023/11/13.
//

import UIKit

@objcMembers
public class UXGradientView: UIView {

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}
