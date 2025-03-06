//
//  String+Ex.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/7/25.
//

import Foundation
import UIKit

extension String {
    func heightForString(_ font: UIFont, _ width: CGFloat, numberLine: Int = 0) -> CGFloat {
        if self.isEmpty {
            return 0
        }
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage = NSTextStorage(attributedString: NSAttributedString(
            string: self,
            attributes: [.font: font]
        ))
        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)
        return layoutManager.usedRect(for: textContainer).integral.size.height
    }
    
    func widthForString(_ font: UIFont, _ height: CGFloat, numberLine: Int = 1) -> CGFloat {
        if self.isEmpty {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage = NSTextStorage(attributedString: NSAttributedString(
            string: self,
            attributes: [.font: font]
        ))
        textStorage.addLayoutManager(layoutManager)
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)
        return layoutManager.usedRect(for: textContainer).integral.size.width
    }
}
