//
//  SwitchAccountController.swift
//  Instagram
//
//  Created by Long Bảo on 21/05/2023.
//

import UIKit

protocol SwitchAccountDelegate: AnyObject {
    func didSelectCreateNewAccountButton(_ viewController: BottomSheetViewCustomController)
    func didSelectLogoutButton(_ viewController: BottomSheetViewCustomController)
}

class SwitchAccountController: BottomSheetViewCustomController {
    //MARK: - Properties
    weak var delegate: SwitchAccountDelegate?
    let containerView = UIView()
    
    private let grabber: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let avartaImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 38 / 2
        return iv
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Keep contacting with your friend"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create new account to keep contacting with your friend"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let createNewAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create new account", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateNewAccountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.alpha = 0.5
        return view
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleLogoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override var heightBottomSheetView: CGFloat {
        return 290
    }
    
    override var maxHeightScrollTop: CGFloat {
        return 40
    }
    
    override var minHeightScrollBottom: CGFloat {
        return 100
    }
    
    override var maxVeclocity: CGFloat {
        return 800
    }
    
    override var bottomSheetView: UIView {
        return containerView
    }

    
    //MARK: - View Lifecycle
    init(imageUser: UIImage?) {
        self.avartaImageView.image = imageUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(grabber)
        containerView.addSubview(avartaImageView)
        containerView.addSubview(mainLabel)
        containerView.addSubview(subLabel)
        containerView.addSubview(createNewAccountButton)
        containerView.addSubview(divider)
        containerView.addSubview(logoutButton)
        containerView.layer.cornerRadius = 23
        
        NSLayoutConstraint.activate([
            grabber.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabber.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            avartaImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avartaImageView.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 20),
            
            mainLabel.topAnchor.constraint(equalTo: avartaImageView.bottomAnchor, constant: 7),
            mainLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 40),
            mainLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -40),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 6),
            subLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 40),
            subLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -40),
            
            createNewAccountButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 16),
            createNewAccountButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 35),
            createNewAccountButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -35),
            createNewAccountButton.heightAnchor.constraint(equalTo: createNewAccountButton.widthAnchor, multiplier: 1 / 7),
            
            divider.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 15),
            divider.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            divider.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            
            logoutButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
            logoutButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

        ])
        avartaImageView.setDimensions(width: 38, height: 38)
        grabber.setDimensions(width: 38, height: 4)
    }
    
    //MARK: - Selectors
    @objc func handleCreateNewAccountButtonTapped() {
        self.delegate?.didSelectCreateNewAccountButton(self)
    }

    @objc func handleLogoutButtonTapped() {
        self.delegate?.didSelectLogoutButton(self)
    }
}

