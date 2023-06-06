//
//  UserLikedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol UserLikedTableViewDelegate: AnyObject {
    func didTapFollowButton(cell: UserLikedTableViewCell, user: UserModel)
}

class UserLikedTableViewCell: UITableViewCell {
    static let identifier = "UserLikedTableViewCell"
    weak var delegate: UserLikedTableViewDelegate?
    
    var viewModel: LikesTableViewCellViewModel? {
        didSet {updateUI()}
    }
    
    lazy var followButton = Utilites.createHeaderProfileButton(with: "Follow")
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 54 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(fullnameLabel)
        contentView.addSubview(followButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -7),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            
            fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 1),
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            fullnameLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -20),
            
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            followButton.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            
        ])
        avatarImageView.setDimensions(width: 54, height: 54)
        followButton.setDimensions(width: 130, height: 33)
        followButton.layer.cornerRadius = 14
        followButton.backgroundColor = .systemBlue
        followButton.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
    }
    
    func updateUI() {
        guard let viewModel = viewModel, let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        viewModel.completion = { [weak self] in
            self?.updateFollowButton()
        }
        
        self.avatarImageView.sd_setImage(with: viewModel.avatarImageUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.fullnameLabel.text = viewModel.fullname
        self.usernameLabel.text = viewModel.username
        if viewModel.user.uid == currentUid {
            followButton.isHidden = true
            return
        } else {
            followButton.isHidden = false
        }
        
        if viewModel.hasFollowed {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = .systemGray3
            followButton.setTitleColor(.label, for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = . systemBlue
            followButton.setTitleColor(.white, for: .normal)
        }
    }
    
    //MARK: - Selectors
    @objc func handleFollowButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didTapFollowButton(cell: self, user: viewModel.user)
    }
    
    func updateFollowButton(hasFollowed: Bool) {
        if hasFollowed {
            self.followButton.setTitle("Following", for: .normal)
            self.followButton.backgroundColor = .systemGray3
            self.followButton.setTitleColor(.label, for: .normal)
        } else {
            self.followButton.setTitle("Follow", for: .normal)
            self.followButton.backgroundColor = .systemBlue
            self.followButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func updateFollowButton() {
        guard let isFollowed = self.viewModel?.hasFollowed else {return}
        
        if isFollowed {
            self.followButton.setTitle("Following", for: .normal)
            self.followButton.backgroundColor = .systemGray3
            self.followButton.setTitleColor(.label, for: .normal)
        } else {
            self.followButton.setTitle("Follow", for: .normal)
            self.followButton.backgroundColor = .systemBlue
            self.followButton.setTitleColor(.white, for: .normal)
        }
    }
}
//MARK: - delegate

