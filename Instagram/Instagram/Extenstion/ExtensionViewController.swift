//
//  ExtensionViewController.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

extension UIViewController {
    var insetTop: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        }
        
        return 0
    }
}
