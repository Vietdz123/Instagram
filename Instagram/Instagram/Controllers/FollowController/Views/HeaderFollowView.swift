//
//  HeaderFollowView.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit

enum HeaderFollowViewType {
    case follower
    case following
    
    var description: String {
        switch self {
        case .follower:
            return "All people followers"
        case .following:
            return "All people followings"
        }
    }
}

class HeaderFollowView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "HeaderFollowView"
    let searchBar = CustomSearchBarView(ishiddenCancelButton: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    var type: HeaderFollowViewType? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle

    //MARK: - Helpers
    func configureUI() {
        addSubview(searchBar)
        addSubview(titleLabel)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
    
    func updateUI() {
        self.titleLabel.text = self.type?.description
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
