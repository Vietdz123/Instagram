//
//  ExploreSearchBarTableViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 24/05/2023.
//

import UIKit
import SDWebImage


class ExploreSearchBarTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ExploreSearchBarTableViewCell"
    var user: UserModel? {
        didSet {updateUI()}
    }
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 44 / 2
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
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(fullnameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            usernameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -0.2),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            
            fullnameLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 0.2),
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            fullnameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            
        ])
        avatarImageView.setDimensions(width: 44, height: 44)
    }
    
    func updateUI() {
        guard let user = user else {
            return
        }
        
        let url = URL(string: user.profileImage ?? "")

        self.usernameLabel.text = user.username
        self.fullnameLabel.text = user.fullname
        self.avatarImageView.sd_setImage(with: url,
                                        placeholderImage: UIImage(systemName: "person.circle"))
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

