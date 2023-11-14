//
//  UXInsetLabel.swift
//  UIKitX
//
//  Created by 梁光辉 on 2023/11/14.
//

import UIKit

public final class UXInsetLabel: UILabel {
    
    public init(frame: CGRect = .zero, contentInset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.contentInset = contentInset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentInset: UIEdgeInsets = .zero
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= contentInset.left;
        rect.origin.y -= contentInset.top;
        rect.size.width += contentInset.left + contentInset.right;
        rect.size.height += contentInset.top + contentInset.bottom;
        return rect
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

}
