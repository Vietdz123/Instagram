//
//  ExtensionLabel.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font ?? .systemFont(ofSize: 15)],
            context: nil).size

        return labelTextSize.height > bounds.size.height && labelText != ""
        
    }
}

extension UITextView {
    func isTruncated(with height: CGFloat) -> Bool {
        guard let labelText = text else {
            return false
        }
        let text = labelText + "gj"
//        let attributedText = NSMutableAttributedString(string: labelText)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 5
//        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
//        self.attributedText = attributedText
        
        let labelTextSize = (text as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font ?? .systemFont(ofSize: 15)],
            context: nil).size

        return labelTextSize.height > height && labelText != ""
    }
    
    var getSpacingLine: CGFloat {
        let paragraph = self.attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle
        let lineSpacing = paragraph?.lineSpacing
        return lineSpacing ?? 0
    }
}
