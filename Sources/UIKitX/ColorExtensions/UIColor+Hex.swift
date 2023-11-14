//
//  UIColor+Hex.swift
//  UIKitX
//
//  Created by 梁光辉 on 2022/1/3.
//

import Foundation
import UIKit

// MARK: Color with Hex

extension UIColor {
    /// 从十六进制中获取颜色，默认 alpha 为1.0
    public static func color(fromHex hex: UInt) -> UIColor {
        return Self.color(fromHex: hex, alpha: 1.0)
    }
    
    /// 从十六进制中获取颜色
    public static func color(fromHex hex: UInt, alpha: CGFloat) -> UIColor {
        return Self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0xFF00) >> 8) / 255.0, blue: CGFloat((hex & 0xFF)) / 255.0, alpha: alpha)
    }
    
    /// 从字符串中获取颜色，其中 alpha 通道可有可无
    public static func color(withRGBAHex rgba: String) -> UIColor? {
        if rgba.count == 0 {
            return nil
        } else {
            var red: CGFloat = 1.0
            var green: CGFloat = 1.0
            var blue: CGFloat = 1.0
            var alpha: CGFloat = 1.0
            var hex = rgba
            
            if hex.hasPrefix("#") {
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                hex = String(hex[startIndex..<hex.endIndex])
            }
            let scanner = Scanner.init(string: hex)
            var hexValue: UInt64 = 0
            if scanner.scanHexInt64(&hexValue) {
                switch hex.count {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    return nil
                }
            } else {
                return nil
            }
            return Self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    /// 从字符串中获取颜色，其中 alpha 通道在第一位（alpha 通道可有可无）
    public static func color(withARGBHex argb: String) -> UIColor? {
        if argb.count == 0 {
            return nil
        } else {
            var alpha: CGFloat = 1.0
            var red: CGFloat = 1.0
            var green: CGFloat = 1.0
            var blue: CGFloat = 1.0
            var hex = argb
            
            if hex.hasPrefix("#") {
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                hex = String(hex[startIndex..<hex.endIndex])
            }
            let scanner = Scanner.init(string: hex)
            var hexValue: UInt64 = 0
            if scanner.scanHexInt64(&hexValue) {
                switch hex.count {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    alpha = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    red = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    alpha = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    red = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    return nil
                }
            } else {
                return nil
            }
            return Self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}
