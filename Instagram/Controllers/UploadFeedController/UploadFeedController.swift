//
//  UploadFeedController.swift
//  Instagram
//
//  Created by Long Bảo on 16/05/2023.
//

import UIKit
import FirebaseAuth

class UploadFeedController: UIViewController {
    //MARK: - Properties
    let loadingIndicator = UIActivityIndicatorView()
    var imageUpload: UIImage? {
        didSet {
            self.headerView.imageUploadImageView.image = imageUpload
        }
    }
    
    let headerView: UploadFeedHeaderView
    
    //MARK: - View Lifecycle
    init(imageUpload: UIImage?) {
        headerView = UploadFeedHeaderView(image: imageUpload)
        self.imageUpload = imageUpload
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleDidTouchScreen)))
        view.isUserInteractionEnabled = true
        self.activeConstraint()
        headerView.delegate = self
    }
    
    func activeConstraint() {
        view.addSubview(headerView)
        view.addSubview(loadingIndicator)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
            
            loadingIndicator.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -12),
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
        ])
    }
    
    func uploadStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let status = headerView.getSatusUpload()
        self.headerView.navigationBar.rightButtons[0].isHidden = true
        self.loadingIndicator.startAnimating()
        StatusService.shared.uploadStatus(image: imageUpload,
                                          uid: uid,
                                          status: status) { [weak self] _ in
            self?.loadingIndicator.stopAnimating()
            self?.tabBarController?.selectedViewController = self?.tabBarController?.viewControllers?.first
            self?.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    //MARK: - Selectors
    @objc func handleDidTouchScreen() {
        self.headerView.statusTextView.endEditing(true)
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: []) {
            self.headerView.imageUploadImageView.transform = .identity
            self.headerView.shadowView.alpha = 0
        }
    }
    
}

//MARK: - delegate
extension UploadFeedController: UploadFeedHeaderDelegate {
    func didSelectShareButton() {
        uploadStatus()
    }
    
    func didSelectBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectUploadImageView() {
        view.layoutIfNeeded()
        let translateTransform = CGAffineTransform(translationX: view.frame.midX - headerView.imageUploadImageView.frame.midX, y: view.frame.midY - headerView.imageUploadImageView.frame.midY)
        let scaleX = view.frame.width / headerView.imageUploadImageView.frame.width
        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        
        self.headerView.shadowView.frame = view.frame
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: []) {
            
            self.headerView.imageUploadImageView.transform = combineTransform
            if self.headerView.imageUploadImageView.frame.width == self.view.frame.width {
                self.headerView.shadowView.alpha = 0.9
            } else {
                self.headerView.shadowView.alpha = 0.0
            }
        }

    }
}
