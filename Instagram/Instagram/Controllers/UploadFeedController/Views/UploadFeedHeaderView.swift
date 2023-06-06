//
//  HeaderUploadFeedController.swift
//  Instagram
//
//  Created by Long Bảo on 16/05/2023.
//

import UIKit

protocol UploadFeedHeaderDelegate: AnyObject {
    func didSelectBackButton()
    func didSelectShareButton()
    func didSelectUploadImageView()
}

class UploadFeedHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: UploadFeedHeaderDelegate?
    var navigationBar: NavigationCustomView!
    var ratio: CGFloat = 0.75
    
    lazy var imageUploadImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handelImageUploadTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viết chú thích..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.layer.zPosition = .greatestFiniteMagnitude
        return label
    }()
    
    lazy var statusTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textColor = .label
        tv.backgroundColor = .systemBackground
        tv.isEditable = true
        tv.isSelectable = true
        return tv
    }()
    
     let shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.0
        view.layer.backgroundColor = UIColor.systemBackground.cgColor
        return view
    }()
    
    //MARK: - View Lifecycle
    init(image: UIImage?) {
        super.init(frame: .zero)
        self.imageUploadImageView.image = image
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        configureProperties()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Helpers
    func configureUI() {
        setupNavigation()
        
        backgroundColor = .systemBackground
        addSubview(placeHolderLabel)
        addSubview(statusTextView)
        addSubview(navigationBar)
        addSubview(shadowView)
        addSubview(imageUploadImageView)

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            
            imageUploadImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 11),
            imageUploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            statusTextView.leftAnchor.constraint(equalTo: imageUploadImageView.rightAnchor, constant: 8),
            statusTextView.topAnchor.constraint(equalTo: imageUploadImageView.centerYAnchor, constant: -43),
            statusTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            statusTextView.heightAnchor.constraint(equalToConstant: 87),
            
            placeHolderLabel.leftAnchor.constraint(equalTo: statusTextView.leftAnchor),
            placeHolderLabel.topAnchor.constraint(equalTo: statusTextView.topAnchor, constant: 5),
        ])

        imageUploadImageView.setDimensions(width: 70, height: 70 / ratio)
        shadowView.layer.zPosition = .greatestFiniteMagnitude
        imageUploadImageView.layer.zPosition = .infinity
    }
    
    func configureProperties() {
        statusTextView.delegate = self
    }
    
    func setupNavigation() {
        let leftButtonAttribute = AttibutesButton(image: UIImage(systemName: "chevron.backward"),
                                                  sizeImage: CGSize(width: 20, height: 20),
                                                  tincolor: .label) { [weak self] in
            self?.delegate?.didSelectBackButton()
        }
        
        let rightButtonAttribute = AttibutesButton(tilte: "Share", 
                                                   font: .systemFont(ofSize: 18, weight: .semibold),
                                                   titleColor: .systemBlue) {  [weak self] in
            self?.delegate?.didSelectShareButton()
        }
        
        self.navigationBar = NavigationCustomView(centerTitle: "New Post",
                                                  centertitleFont: .systemFont(ofSize: 18, weight: .bold),
                                                  attributeLeftButtons: [leftButtonAttribute],
                                                  attributeRightBarButtons: [rightButtonAttribute],
                                                  beginSpaceLeftButton: 9, beginSpaceRightButton: 9)
    }
    
    func getSatusUpload() -> String {
        return self.statusTextView.text
    }
    
    //MARK: - Selectors
    @objc func handelImageUploadTapped() {
        delegate?.didSelectUploadImageView()
    }

    
}
//MARK: - delegate
extension UploadFeedHeaderView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if statusTextView.text?.count == 0 {
            placeHolderLabel.isHidden = false
        }
    }
}
