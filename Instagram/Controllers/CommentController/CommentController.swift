//
//  CommentController.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import SDWebImage

protocol CommentDelegate: AnyObject {
    func didPostComment(numberComments: Int)
}

class CommentController: UIViewController {
    //MARK: - Properties
    var viewModel = CommentViewModel()
    
    weak var delegate: CommentDelegate?
    var navigationbar: NavigationCustomView!
    var collectionView: UICollectionView!
    var bottomContainerViewConstraint: NSLayoutConstraint!
    var heightContainerInputViewConstraint: NSLayoutConstraint!
    private let containerInputView = ContainerInputCustomView()
    private let beginHeightContainerInputView: CGFloat = 43
    private let plusHeightTextView: CGFloat = 28
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 38 / 2
        return iv
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.alpha = 0.5
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addSubview(avatarImageView)
        view.addSubview(divider)
        view.addSubview(containerInputView)
        containerInputView.backgroundColor = .systemBackground
        containerInputView.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightContainerInputViewConstraint = containerInputView.heightAnchor.constraint(equalToConstant: beginHeightContainerInputView)
        NSLayoutConstraint.activate([
            avatarImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            avatarImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            containerInputView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            containerInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            containerInputView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            containerInputView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            heightContainerInputViewConstraint,
            
            divider.topAnchor.constraint(equalTo: view.topAnchor),
            divider.leftAnchor.constraint(equalTo: view.leftAnchor),
            divider.rightAnchor.constraint(equalTo: view.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        avatarImageView.setDimensions(width: 38, height: 38)
        return view
    }()
    
    //MARK: - View Lifecycle
    init(status: StatusModel, currentUser: UserModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.status = status
        self.viewModel.currentUser = currentUser
        self.avatarImageView.sd_setImage(with: viewModel.avatarCurrentUserUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.fetchData()
        self.viewModel.completionFetchComment = { [weak self] in
            self?.delegate?.didPostComment(numberComments: self!.viewModel.numberComments)
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: CommentVC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureProperties()
        addNotification()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Helpers
    func fetchData() {
        self.viewModel.fetchComment()
    }
    
    func configureUI() {
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayoutCollectionView())
        view.addSubview(navigationbar)
        view.addSubview(collectionView)
        view.addSubview(containerView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        
        bottomContainerViewConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: navigationbar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            bottomContainerViewConstraint,
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
        ])
    }
    

    
    func configureProperties() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDidEndEditing)))
        containerInputView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CommentCollectionViewCell.self,
                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        collectionView.register(CommentHeaderCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CommentHeaderCollectionView.identifier)

    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyBoardWillAppearce),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyBoardWillHide),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "arrow-left"),
                                                       sizeImage: CGSize(width: 26, height: 26)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
                                                   
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "share"),
                                                        sizeImage: CGSize(width: 28, height: 28))
                                                   
        self.navigationbar = NavigationCustomView(centerTitle: "Comment",
                                              attributeLeftButtons: [attributeFirstLeftButton],
                                              attributeRightBarButtons: [attributeFirstRightButton],
                                              beginSpaceLeftButton: 15,
                                              beginSpaceRightButton: 15)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(300))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(300))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section: NSCollectionLayoutSection
        if viewModel.status.caption == "" {
            section = ComposionalLayout.createSectionWithouHeader(group: group)
        } else {
            section = ComposionalLayout.createSection(group: group)
        }
        section.interGroupSpacing = 2
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Selectors
    @objc func handleDidEndEditing() {
        self.containerInputView.inputTextView.endEditing(true)
    }
    
    @objc func handleKeyBoardWillAppearce(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
              let keyboardHeight = keyboardSize.height
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            UIView.animate(withDuration: 0.2) {
                self.bottomContainerViewConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            }
          }
    }
    
    @objc func handleKeyBoardWillHide() {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        UIView.animate(withDuration: 0.2) {
            self.bottomContainerViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}
//MARK: - delegate
extension CommentController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier
                                                      , for: indexPath) as! CommentCollectionViewCell
        
        let comment = viewModel.commentAtIndexPath(indexpath: indexPath)
        cell.viewModel = CommentCollectionViewCellViewModel(comment: comment)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberComments
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: CommentHeaderCollectionView.identifier,
                                                                     for: indexPath) as! CommentHeaderCollectionView
        header.status = self.viewModel.status
        return header
    }
}

extension CommentController: ContainerInputDelegate {
    func didTapPostButton(textView: UITextView) {
        let isOnlyWhitespace = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if !isOnlyWhitespace {
            viewModel.uploadComment(caption: textView.text)
            textView.text = ""
            textView.endEditing(true)
        }
    }
    
    func didChangeEditTextView(textView: UITextView) {
        if textView.isTruncated(with: self.containerInputView.heightInputTextView)
            && self.heightContainerInputViewConstraint.constant < self.beginHeightContainerInputView + self.plusHeightTextView * 2 + 2 {
            UIView.animate(withDuration: 0.1) {
                self.heightContainerInputViewConstraint.constant += self.plusHeightTextView
                self.containerInputView.heightInputTextView += self.plusHeightTextView
                self.containerInputView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        } else if !textView.isTruncated(with: self.containerInputView.heightInputTextView - self.plusHeightTextView)
                    && self.heightContainerInputViewConstraint.constant != self.beginHeightContainerInputView  {
            UIView.animate(withDuration: 0.1) {
                self.heightContainerInputViewConstraint.constant -= self.plusHeightTextView
                self.containerInputView.heightInputTextView -= self.plusHeightTextView
                self.containerInputView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
        
        if textView.text == "" {
            UIView.animate(withDuration: 0.1) {
                self.heightContainerInputViewConstraint.constant = self.beginHeightContainerInputView
                self.containerInputView.heightInputTextView = 19
                self.containerInputView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }

    }
    
    
}

extension CommentController: CommentCollectionViewDelegate {
    func didSelectAvatarOrUsername(user: UserModel) {
        let profileVC = ProfileController(user: user, type: .other)
        profileVC.hidesBottomBarWhenPushed = false
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
