//
//  File.swift
//  UIKitZen
//
//  Created by 梁光辉 on 2023/11/13.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// get **UIImage** from a base64 string.
    /// - Parameter url: encoded **base64 str** from a image data, prefixed by **data**
    /// - Returns: UIImage. May be nil if the base64 str is invalid
    @objc static func image(withBase64Str str: String) -> UIImage? {
        guard let imageUrl = URL(string: str) else {
            return nil
        }
        
        assert(imageUrl.scheme == "data", "Invalid base64 string!")
        
        do {
            let data = try Data(contentsOf: imageUrl)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
