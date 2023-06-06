//
//  BottomCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

class BottomTabBarCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomTabBarCollectionViewCell"
    var heightTitleConstraint: NSLayoutConstraint!
    var titleBottom: TitleTabStripBottom? {
        didSet {
            updateUI()
        }
    }
    
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(titleButton)
        backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            titleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
        ])
    }

    func updateUI() {
        guard let titleBottom = titleBottom else {
            return
        }

        if let titleImage = titleBottom.titleImage {
            titleButton.setImage(titleImage.image, for: .normal)
            titleButton.setDimensions(width: titleImage.size.width, height: titleImage.size.height)
            titleButton.tintColor = titleImage.tinColor
            titleButton.contentVerticalAlignment = .fill
            titleButton.contentHorizontalAlignment = .center
            NSLayoutConstraint.activate([
                titleButton.heightAnchor.constraint(equalToConstant: titleImage.size.height)
            ])
        } else {
            let titleLabel = titleBottom.titleString
            titleButton.setTitle(titleLabel.title, for: .normal)
            titleButton.setTitleColor(titleLabel.titleColor, for: .normal)
            titleButton.titleLabel?.font = titleLabel.font
        }
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate



