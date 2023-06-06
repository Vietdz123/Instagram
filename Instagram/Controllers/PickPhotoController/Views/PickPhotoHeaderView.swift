//
//  UploadHeaderPhotoView.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//


import UIKit

protocol PickHeaderPhotoDelegate: AnyObject {
    func didSelectbackButtonTapped()
    func didSelectNexButton()
    func didSelectCamera()
}

class PickPhotoHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: PickHeaderPhotoDelegate?
    var naviationBar: NavigationCustomView!
    let heightHeaderTitle: CGFloat = 35
    let heightBottomCamera: CGFloat = 42
        
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.tintColor = UIColor.white
        iv.layer.cornerRadius = 32 / 2
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.systemGray.cgColor
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleCameraImageViewTapped)))
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
        setupNavigationbar()
        
        backgroundColor = .black
        addSubview(photoImageView)
        addSubview(cameraImageView)
        addSubview(naviationBar)
        naviationBar.translatesAutoresizingMaskIntoConstraints = false
        naviationBar.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            naviationBar.leftAnchor.constraint(equalTo: leftAnchor),
            naviationBar.rightAnchor.constraint(equalTo: rightAnchor),
            naviationBar.topAnchor.constraint(equalTo: topAnchor),
            naviationBar.heightAnchor.constraint(equalToConstant: self.heightHeaderTitle),
            
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.topAnchor.constraint(equalTo: naviationBar.bottomAnchor),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            cameraImageView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            cameraImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            cameraImageView.heightAnchor.constraint(equalToConstant: 32),
            cameraImageView.widthAnchor.constraint(equalTo: cameraImageView.heightAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -5)
        ])
    }
    
    func setupNavigationbar() {
        let leftButtonAttribute = AttibutesButton(image: UIImage(systemName: "xmark"),
                                                  sizeImage: CGSize(width: 23, height: 23),
                                                  tincolor: .white) {
            self.delegate?.didSelectbackButtonTapped()
        }
        
        let rightButtonAttribute = AttibutesButton(tilte: "Next",
                                                   font: .systemFont(ofSize: 20, weight: .semibold),
                                                   titleColor: .systemBlue) {
            self.delegate?.didSelectNexButton()
        }
        
        self.naviationBar = NavigationCustomView(centerTitle: "New Post",
                                                 centertitleFont: .systemFont(ofSize: 18, weight: .semibold),
                                                 centerColor: .white,
                                                 attributeLeftButtons: [leftButtonAttribute],
                                                 attributeRightBarButtons: [rightButtonAttribute],
                                                 isHiddenDivider: true,
                                                 beginSpaceLeftButton: 9,
                                                 beginSpaceRightButton: 9)
    }
    
    //MARK: - Selectors
    @objc func handleCameraImageViewTapped() {
        delegate?.didSelectCamera()
    }
    
}
//MARK: - delegate
