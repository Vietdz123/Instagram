//
//  CommentHeaderCollectionView.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import UIKit
import SDWebImage

class CommentHeaderCollectionView: UICollectionReusableView {
    //MARK: - Properties
    var status: StatusModel? {
        didSet {updateUI()}
    }
    static let identifier = "CommentHeaderCollectionView"
    var bottomConstraint: NSLayoutConstraint!
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "b_lackBink"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "4 hour"
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.alpha = 0.4
        return view
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        addSubview(dateLabel)
        addSubview(captionLabel)
        addSubview(divider)
        
        self.bottomConstraint = captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        self.bottomConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 0),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            dateLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 7),
            
            captionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            captionLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor),
            captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -22),
            bottomConstraint,
            
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leftAnchor.constraint(equalTo: leftAnchor),
            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        avatarImageView.setDimensions(width: 36, height: 36)
    }
    
    func updateUI() {
        guard let status = status else {
            return
        }

        let avatarUrl = URL(string: status.user.profileImage ?? "")
        self.avatarImageView.sd_setImage(with: avatarUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.captionLabel.text = status.caption
        self.usernameLabel.text = status.user.username
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        self.dateLabel.text = formatter.string(from: status.timeStamp)
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

