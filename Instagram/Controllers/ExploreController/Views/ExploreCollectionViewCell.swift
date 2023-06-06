//
//  ExploreCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 24/05/2023.
//

import UIKit
import SDWebImage

class ExploreCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ExploreCollectionViewCell"
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    lazy var photoImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
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
        backgroundColor = .red
        addSubview(photoImage)
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor),
            photoImage.leftAnchor.constraint(equalTo: leftAnchor),
            photoImage.rightAnchor.constraint(equalTo: rightAnchor),
            photoImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateUI() {
        photoImage.sd_setImage(with: imageURL)
    }
    //MARK: - Selectors
    
}
//MARK: - delegate
