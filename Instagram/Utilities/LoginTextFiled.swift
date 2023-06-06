//
//  TextField.swift
//  Instagram
//
//  Created by Long Bảo on 21/05/2023.
//

import UIKit

class LoginTextFiled: UITextField {
    let padding = UIEdgeInsets(top: 13.5, left: 15, bottom: 13.5, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
