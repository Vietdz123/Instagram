//
//  ContainerInputView.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit

protocol ContainerInputDelegate: AnyObject {
    func didTapPostButton(textView: UITextView)
    func didChangeEditTextView(textView: UITextView)
}

class ContainerInputCustomView: UIView {
    //MARK: - Properties
    weak var delegate: ContainerInputDelegate?
    var heightInputTextView: CGFloat = 19
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Comment..."
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var inputTextView: UITextView = {
        let iv = UITextView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isEditable = true
        iv.isUserInteractionEnabled = true
        iv.isScrollEnabled = true
        iv.font = UIFont.systemFont(ofSize: 15)
        iv.delegate = self
        iv.textAlignment = .left
        iv.text = ""
        return iv
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePostButtonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .systemBackground
        addSubview(inputTextView)
        addSubview(postButton)
        addSubview(placeHolderLabel)
        layer.cornerRadius = 19
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            inputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            placeHolderLabel.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor),
            placeHolderLabel.leftAnchor.constraint(equalTo: inputTextView.leftAnchor, constant: 5),
            
            postButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            postButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            postButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: 10),
        ])
        postButton.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)
        postButton.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        layoutIfNeeded()
    }
    
    //MARK: - Selectors
    @objc func handlePostButtonTapped() {
        self.delegate?.didTapPostButton(textView: self.inputTextView)
    }
    
}
//MARK: - delegate
extension ContainerInputCustomView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.didChangeEditTextView(textView: textView)
        
    }
}
