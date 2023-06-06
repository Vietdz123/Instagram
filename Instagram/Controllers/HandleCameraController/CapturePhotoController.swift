//
//  CapturePhotoController.swift
//  Instagram
//
//  Created by Long Bảo on 17/05/2023.
//

import UIKit
import Photos

protocol CapturePhotoDelegate: AnyObject {
    func didSlectSaveButton(image: UIImage?)
}

class CapturePhotoController: UIViewController {
    //MARK: - Properties
    let type: UsingPickPhotoType
    weak var delegate: CapturePhotoDelegate?

    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jennie"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var saveImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "square.and.arrow.down"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleSaveImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var backImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "xmark"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleBackImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveImageView)
        view.addSubview(backImageView)
        
        NSLayoutConstraint.activate([
            saveImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            backImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        ])
        saveImageView.setDimensions(width: 30, height: 30)
        backImageView.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    
    //MARK: - View Lifecycle

    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    init(image: UIImage?, type: UsingPickPhotoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        self.photoImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        activeConstraint()
    }
    
    func activeConstraint() {
        view.addSubview(photoImageView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    //MARK: - Selectors
    @objc func handleSaveImageTapped() {
        guard let image = self.photoImageView.image else {return}
        PHPhotoLibrary.shared().performChanges {

            PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                    print("DEBUG: cannot save photo \(error.localizedDescription)")
                } else {
                    print("DEBUG: save image success")
                }
                DispatchQueue.main.async {
                    if self.type == .uploadTus {
                        self.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                    
                    self.delegate?.didSlectSaveButton(image: image)
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                }
            }
    }
    
    @objc func handleBackImageTapped() {
        self.navigationController?.popViewController(animated: true)

    }
    
}
//MARK: - delegate
