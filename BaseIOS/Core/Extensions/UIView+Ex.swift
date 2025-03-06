//
//  UIView+Ex.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import UIKit

extension UIView {
    var rootView: UIView {
        superview?.rootView ?? self
    }
    
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setShadow(color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 2)) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
    }
}
