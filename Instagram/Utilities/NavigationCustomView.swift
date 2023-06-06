//
//  NavigationCustomViewSecond.swift
//  Instagram
//
//  Created by Long Bảo on 19/05/2023.
//

import UIKit

struct AttibutesButton {
    var tilte: String?
    var image: UIImage?
    var sizeImage: CGSize = CGSize(width: 25, height: 25)
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    var titleColor: UIColor = .label
    var tincolor: UIColor = .label
    
    var didSelectButton: (() -> Void)?
}

class NavigationCustomView: UIView {
    //MARK: - Properties
    private var leftBarButtons: [UIButton] = []
    private var rightBarButtons: [UIButton] = []
    private var beginSpaceLeftButton: CGFloat = 10
    private var beginSpaceRightButton: CGFloat = 10
    private var continueSpaceleft: CGFloat = 10
    private var continueSpaceRight: CGFloat = 10
    private var attributedTitle: NSAttributedString?
    private var centerTitle: String?
    private var centertitleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    private var centerColor: UIColor = .label
    private var attributeLeftBarButtons: [AttibutesButton] = []
    private var attrubuteRightBarButtons: [AttibutesButton] = []
    
    var leftButtons: [UIButton] {
        return leftBarButtons
    }
    
    var rightButtons: [UIButton] {
        return rightBarButtons
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.centerTitle
        label.font = self.centertitleFont
        label.textColor = self.centerColor
        if let attributedTitle = attributedTitle {
            label.attributedText = attributedTitle
            label.numberOfLines = 2
            label.textAlignment = .center
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.alpha = 0.4
        return view
    }()
    
    //MARK: - View Lifecycle
    init(centerTitle: String? = nil,
         attributedTitle: NSAttributedString? = nil,
         centertitleFont: UIFont = .systemFont(ofSize: 16, weight: .bold),
         centerColor: UIColor = .label,
         attributeLeftButtons: [AttibutesButton],
         attributeRightBarButtons: [AttibutesButton],
         isHiddenDivider: Bool = false,
         beginSpaceLeftButton: CGFloat = 10,
         beginSpaceRightButton: CGFloat = 10,
         continueSpaceleft: CGFloat = 10,
         continueSpaceRight: CGFloat = 10) {
        
        self.attributeLeftBarButtons = attributeLeftButtons
        self.attributedTitle = attributedTitle
        self.attrubuteRightBarButtons = attributeRightBarButtons
        self.headerDivider.isHidden = isHiddenDivider
        self.centerTitle = centerTitle
        self.centerColor = centerColor
        self.centertitleFont = centertitleFont
        self.beginSpaceLeftButton = beginSpaceLeftButton
        self.beginSpaceRightButton = beginSpaceRightButton
        self.continueSpaceleft = continueSpaceleft
        self.continueSpaceRight = continueSpaceRight
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(titleLabel)
        addSubview(headerDivider)
        backgroundColor = .systemBackground
        
        for attribute in attributeLeftBarButtons {
            let button = UIButton(type: .system)
            if let title = attribute.tilte {
                button.setTitle(title, for: .normal)
                button.setTitleColor(attribute.titleColor, for: .normal)
                button.titleLabel?.font = attribute.font
            } else {
                button.setImage(attribute.image, for: .normal)
                button.setDimensions(width: attribute.sizeImage.width,
                                     height: attribute.sizeImage.height)
                button.contentMode = .scaleToFill
                button.tintColor = attribute.tincolor
                button.contentVerticalAlignment = .fill
                button.contentHorizontalAlignment = .fill
            }
            button.addTarget(self, action: #selector(didTapNavigationLeftButton), for: .touchUpInside)
            self.leftBarButtons.append(button)
        }
        
        for attribute in attrubuteRightBarButtons {
            let button = UIButton(type: .system)
            if let title = attribute.tilte {
                button.setTitle(title, for: .normal)
                button.setTitleColor(attribute.titleColor, for: .normal)
                button.titleLabel?.font = attribute.font
            } else {
                button.setImage(attribute.image, for: .normal)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: attribute.sizeImage.width),
                    button.heightAnchor.constraint(equalToConstant: attribute.sizeImage.height),
                ])
                button.contentMode = .scaleAspectFill
                button.tintColor = attribute.tincolor
                button.contentVerticalAlignment = .fill
                button.contentHorizontalAlignment = .fill
            }
            button.addTarget(self, action: #selector(didTapNavigationRightButton), for: .touchUpInside)
            self.rightBarButtons.append(button)
        }
        
        for (index, button) in leftBarButtons.enumerated() {
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false

            if index == 0 {
                NSLayoutConstraint.activate([
                    button.leftAnchor.constraint(equalTo: leftAnchor,
                                                 constant: self.beginSpaceLeftButton),
                    button.centerYAnchor.constraint(equalTo: centerYAnchor),
                ])
                continue
            }
            
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: centerYAnchor),
                leftBarButtons[index].leftAnchor.constraint(equalTo: leftBarButtons[index - 1].rightAnchor,
                                                            constant: self.continueSpaceleft)
            ])
        }
        
        for (index, button) in rightBarButtons.enumerated() {
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                NSLayoutConstraint.activate([
                    button.rightAnchor.constraint(equalTo: rightAnchor,
                                                  constant: -self.beginSpaceRightButton),
                    button.centerYAnchor.constraint(equalTo: centerYAnchor),
                ])
                continue
            }
            
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            
            NSLayoutConstraint.activate([
                rightBarButtons[index].rightAnchor.constraint(equalTo: rightBarButtons[index - 1].leftAnchor,
                                                              constant: -self.continueSpaceRight)
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            headerDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerDivider.leftAnchor.constraint(equalTo: leftAnchor),
            headerDivider.rightAnchor.constraint(equalTo: rightAnchor),
            headerDivider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        
    }
    
    //MARK: - Selectors
    @objc func didTapNavigationLeftButton(sender: UIButton) {
        for (index, button) in self.leftBarButtons.enumerated() {
            if button == sender {
                self.attributeLeftBarButtons[index].didSelectButton?()
            }
        }
    }
    
    @objc func didTapNavigationRightButton(sender: UIButton) {
        for (index, button) in self.rightBarButtons.enumerated() {
            if button == sender {
                self.attrubuteRightBarButtons[index].didSelectButton?()
            }
        }

    }
    
}
//MARK: - delegate
