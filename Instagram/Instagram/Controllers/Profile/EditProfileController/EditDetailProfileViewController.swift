//
//  EditNameUserController.swift
//  Instagram
//
//  Created by Long Bảo on 19/05/2023.
//

import UIKit

protocol EditDetailDelegate: AnyObject {
    func didSelectDoneButton(type: EđitDetailProfileType, text: String)
}

enum EđitDetailProfileType: Int, CaseIterable {
    case fullname
    case username
    case link
    
    var description: String {
        switch self {
        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .link:
            return "Link"
        }
    }
}

class EditDetailProfileViewController: UIViewController {
    //MARK: - Properties
    var naviationBar: NavigationCustomView!
    let typeEdit: EđitDetailProfileType
    weak var delegate: EditDetailDelegate?
    let user: UserModel
    
    var infoUser: String? {
        switch typeEdit {
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .link:
            return user.link
        }
    }
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = self.typeEdit.description
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enterInfoTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.becomeFirstResponder()
        tf.text = self.infoUser
        return tf
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    //MARK: - View Lifecycle
    init(type: EđitDetailProfileType, user: UserModel) {
        self.typeEdit = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: EditDetail deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helpers
    func configureUI() {
        setupNaviationbar()
        view.backgroundColor = .systemBackground
        view.addSubview(naviationBar)
        view.addSubview(usernameLabel)
        view.addSubview(enterInfoTextField)
        view.addSubview(divider)
        
        NSLayoutConstraint.activate([
            naviationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            naviationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            naviationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            naviationBar.heightAnchor.constraint(equalToConstant: 45),
            
            usernameLabel.topAnchor.constraint(equalTo: naviationBar.bottomAnchor, constant: 6),
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            
            enterInfoTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            enterInfoTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            enterInfoTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -13),
            
            divider.topAnchor.constraint(equalTo: enterInfoTextField.bottomAnchor, constant: 6),
            divider.leftAnchor.constraint(equalTo: view.leftAnchor),
            divider.rightAnchor.constraint(equalTo: view.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    
    func setupAttributes() {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handelScreenTouched)))
    }
    
    func setupNaviationbar() {
        let attributeLeftButton = AttibutesButton(image: UIImage(systemName: "lessthan"),
                                                  sizeImage: CGSize(width: 18, height: 25),
                                                  tincolor: .label) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let attributeRightButton = AttibutesButton(tilte: "Done",
                                                   font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                   titleColor: .systemBlue) { [weak self] in
            self?.delegate?.didSelectDoneButton(type: self?.typeEdit ?? .fullname, text: self?.enterInfoTextField.text ?? "")
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.naviationBar = NavigationCustomView(centerTitle: self.typeEdit.description,
                                                        attributeLeftButtons: [attributeLeftButton],
                                                        attributeRightBarButtons: [attributeRightButton])
    }
    //MARK: - Selectors
    @objc func handelScreenTouched() {
        self.enterInfoTextField.endEditing(true)
    }
    
}
//MARK: - delegate
