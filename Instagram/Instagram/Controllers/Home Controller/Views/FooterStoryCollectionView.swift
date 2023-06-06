//
//  FooterStoryCollectionView.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//

import UIKit


class FooterStoryCollectionView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "FooterStoryCollectionView"
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
        backgroundColor = .gray
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
