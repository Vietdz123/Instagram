//
//  InstagramHeaderView.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

import UIKit

protocol InstagramHeaderViewDelegate: AnyObject {
    func didSelectInstagramLabel()
}

class BadgeValueLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setDimensions(width: 18, height: 18)
        layer.cornerRadius = 18 / 2
        layer.masksToBounds = true
        backgroundColor = .red
        textColor = .white
        text = "1"
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InstagramHeaderView: UIView {
    //MARK: - Properties
    lazy var messageBadgeValueLabel = BadgeValueLabel(frame: .zero)
    lazy var likeBadgeValueLabel = BadgeValueLabel(frame: .zero)
    weak var delegate: InstagramHeaderViewDelegate?
    
    private lazy var logoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logo"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleLogoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sublogoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .label
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "message"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, messageButton])
        stackView.axis = .horizontal
        stackView.spacing = 21
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        backgroundColor = .systemBackground
        addSubview(logoButton)
        addSubview(sublogoImageView)
        addSubview(buttonStackView)
        addSubview(likeBadgeValueLabel)
        addSubview(messageBadgeValueLabel)
        
        NSLayoutConstraint.activate([
            logoButton.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 1),
            logoButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1),
            
            sublogoImageView.leftAnchor.constraint(equalTo: logoButton.rightAnchor, constant: -11),
            sublogoImageView.centerYAnchor.constraint(equalTo: logoButton.centerYAnchor),
            
            buttonStackView.centerYAnchor.constraint(equalTo: logoButton.centerYAnchor),
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -21),
            
            messageBadgeValueLabel.bottomAnchor.constraint(equalTo: messageButton.topAnchor, constant: 8),
            messageBadgeValueLabel.leftAnchor.constraint(equalTo: messageButton.rightAnchor, constant: -8),
            
            likeBadgeValueLabel.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: 10),
            likeBadgeValueLabel.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: -10),
        ])
        logoButton.setDimensions(width: 130, height: 55)
        sublogoImageView.setDimensions(width: 30, height: 20)
    }
    
    //MARK: - Selectors
    @objc func  handleLogoButtonTapped() {
        self.delegate?.didSelectInstagramLabel()
    }
    
}
//MARK: - delegate
