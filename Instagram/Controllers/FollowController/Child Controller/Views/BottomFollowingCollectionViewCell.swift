//
//  BottomFollowingCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit
import SDWebImage

protocol BottomFollowingCellDelegate: AnyObject {
    func didSelectFollowButton(cell: BottomFollowingCollectionViewCell, user: UserModel)
}

class BottomFollowingCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomFollowingCollectionViewCell"
    var centerYUsernameConstraint: NSLayoutConstraint!
    weak var delegate: BottomFollowingCellDelegate?

    var viewModel: FollowCellViewModel? {
        didSet {configureUI()}
    }
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 56 / 2
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "b_lackBink"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.text = "b_lackBink"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("follow", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Following", for: .normal)
        button.backgroundColor = .systemGray3
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
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
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
        addSubview(followButton)
        
        self.centerYUsernameConstraint = self.usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8)
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            usernameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            centerYUsernameConstraint,
            
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3),
            
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
        avatarImageView.setDimensions(width: 56, height: 56)
        followButton.setDimensions(width: 105, height: 33)
        followButton.layer.cornerRadius = 15
        
        guard let viewModel = viewModel else {
            return
        }
        let hasFollowed = viewModel.hasFollowed

        
        self.avatarImageView.sd_setImage(with: viewModel.avatarUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.usernameLabel.text = viewModel.username
        self.fullnameLabel.text = viewModel.fullname
        
        if viewModel.isCurrentUser {
            self.followButton.isHidden = true
        } else {
            self.followButton.isHidden = false
        }
        
        if hasFollowed {
            followButton.setTitle("following", for: .normal)
            followButton.backgroundColor = .systemGray3
            followButton.setTitleColor(.label, for: .normal)
        } else {
            followButton.setTitle("follow", for: .normal)
            followButton.backgroundColor = .systemBlue
            followButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func updateFollowButtonAfterTapped() {
        guard let hasFollowed = viewModel?.hasFollowed else {return}
        if hasFollowed {
            followButton.setTitle("following", for: .normal)
            followButton.backgroundColor = .systemGray3
            followButton.setTitleColor(.label, for: .normal)
        } else {
            followButton.setTitle("follow", for: .normal)
            followButton.backgroundColor = .systemBlue
            followButton.setTitleColor(.white, for: .normal)
        }
    }
    
    //MARK: - Selectors
    @objc func handleFollowButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectFollowButton(cell: self, user: viewModel.user)
    }
    
    
}
//MARK: - delegate

