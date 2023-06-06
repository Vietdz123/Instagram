//
//  RegisterController.swift
//  Instagram
//
//  Created by Long Bảo on 04/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class RegisterController: UIViewController {
    //MARK: - Properties
    let db = Firestore.firestore()
    
    private lazy var usernameTextFiled = Utilites.createTextField(with: "Username", with: "mdgarp49")
    private lazy var fullnameTextField = Utilites.createTextField(with: "Fullname", with: "vietdz")
    private lazy var emailTextField = Utilites.createTextField(with: "Email", with: "viet@gmail.com")
    private lazy var passwordTextField = Utilites.createTextField(with: "Password", with: "123456")
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Register"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 4
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.clipsToBounds = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRegisterLabelTapped)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5.1
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var inforStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextFiled,
                                                      fullnameTextField,
                                                      emailTextField,
                                                      passwordTextField])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.errorLabel.isHidden = true
    }
    
    //MARK: - Helpers
    func configureUI() {
        navigationController?.navigationItem.title = "Register Account"
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(inforStackView)
        view.addSubview(registerLabel)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            inforStackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            inforStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            inforStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            registerLabel.topAnchor.constraint(equalTo: inforStackView.bottomAnchor, constant: 15),
            registerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            registerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            registerLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 10),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
    }
    
    func activeErrorLabel(with text: String) {
        self.errorLabel.text = text
        self.errorLabel.isHidden = false
    }
    
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegisterLabelTapped() {
        guard let usermame = usernameTextFiled.text,
              let fullname = fullnameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {
                  return
              }
        if usermame == "" || fullname == "" {
            self.activeErrorLabel(with: "Username, fullname, email or password must not be empty")
            return
        }
        
        let auth = AuthCrentials(email: email,
                                 password: password,
                                 fullName: fullname,
                                 userName: usermame)
        
        AuthService.shared.registerUser(authCretical: auth) { error in
            if let error = error {
                self.activeErrorLabel(with: error.localizedDescription)
                return
            }
            self.errorLabel.isHidden = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
//MARK: - delegate
