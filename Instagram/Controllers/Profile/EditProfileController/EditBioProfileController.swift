//
//  EditBioController.swift
//  Instagram
//
//  Created by Long Bảo on 19/05/2023.
//

import UIKit

protocol EditBioDelegate: AnyObject {
    func didSelectDoneButton(text: String)
}

class EditBioProfileController: UIViewController {
    //MARK: - Properties
    var naviationBar: NavigationCustomView!
    let bio: String
    weak var delegate: EditBioDelegate?
    
    lazy var bioTextView: UITextView = {
        let iv = UITextView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isEditable = true
        iv.isUserInteractionEnabled = true
        iv.isScrollEnabled = false
        iv.font = UIFont.systemFont(ofSize: 16)
        iv.text = self.bio
        iv.becomeFirstResponder()
        return iv
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    //MARK: - View Lifecycle
    init(bio: String) {
        self.bio = bio
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("DEBUG: EditBio deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.addSubview(bioTextView)
        view.addSubview(divider)
        
        NSLayoutConstraint.activate([
            naviationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            naviationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            naviationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            naviationBar.heightAnchor.constraint(equalToConstant: 45),
            
            bioTextView.topAnchor.constraint(equalTo: naviationBar.bottomAnchor, constant: 8),
            bioTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            bioTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            divider.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 8),
            divider.leftAnchor.constraint(equalTo: view.leftAnchor),
            divider.rightAnchor.constraint(equalTo: view.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    
    func setupAttributes() {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelScreenTouched)))
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
            self?.delegate?.didSelectDoneButton(text: self?.bioTextView.text ?? "")
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.naviationBar = NavigationCustomView(centerTitle: "Bio",
                                                attributeLeftButtons: [attributeLeftButton],
                                                attributeRightBarButtons: [attributeRightButton])
    }
    //MARK: - Selectors
    @objc func handelScreenTouched() {
        self.bioTextView.endEditing(true)
    }
    
}
//MARK: - delegate
