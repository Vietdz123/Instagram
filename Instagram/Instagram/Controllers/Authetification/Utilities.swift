//
//  Utilities.swift
//  Instagram
//
//  Created by Long Bảo on 03/05/2023.
//

import UIKit

class Utilites {
    static func createTextField(with placeholder: String, with text: String? = nil) -> LoginTextFiled {
        let tf = LoginTextFiled()
        tf.textColor = .black
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.backgroundColor = .white
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 6.3
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(rgb: 0x5A686C)])
        tf.text = text
        return tf
    }
    
    static func createHeaderProfileInfoLabel(type: HeaderType, with number: String) -> UILabel {
        let infoLabel = UILabel()
        infoLabel.text = type.rawValue
        infoLabel.textColor = .label
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(number)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: type.rawValue,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.label]))
        infoLabel.attributedText = attributedText
        infoLabel.numberOfLines = 2
        infoLabel.textAlignment = .center
        return infoLabel
    }
    
    static func createHeaderProfileButton(with text: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.backgroundColor = .systemGray3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5.3
        button.setTitleColor(.label, for: .normal)
        return button
    }
    
    static func createStatusFeedLabel(username: String, status: String, fontSize: CGFloat = 14) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributes = NSMutableAttributedString(string: "\(username) ", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold), .foregroundColor: UIColor.label])
        attributes.append(NSAttributedString(string: status, attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular), .foregroundColor: UIColor.label]))
        label.attributedText = attributes
        label.numberOfLines = 2
        return label
    }
    

    
}

