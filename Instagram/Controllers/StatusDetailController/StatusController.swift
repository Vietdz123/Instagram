//
//  StatusDetailController.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import UIKit


class StatusController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView!
    var navigationbar: NavigationCustomView!
    let status: StatusModel
    let currentUser: UserModel
    var attributedTitle: NSAttributedString?
    
    //MARK: - View Lifecycle
    init(status: StatusModel,
         user: UserModel,
         attributedTitle: NSAttributedString? = nil) {
        self.status = status
        self.currentUser = user
        self.attributedTitle = attributedTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationbar()
        view.addSubview(collectionView)
        view.addSubview(navigationbar)
        view.backgroundColor = .systemBackground
        
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 55),
            
            collectionView.topAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeFeedCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
    }
    
    func setupNavigationbar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(systemName: "chevron.backward"),
                                                       sizeImage: CGSize(width: 20, height: 25),
                                                       tincolor: .label) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }


        let navigationBar = NavigationCustomView(centerTitle: "Explore",
                                                 attributedTitle: self.attributedTitle,
                                                 attributeLeftButtons: [attributeFirstLeftButton],
                                                 attributeRightBarButtons: [],
                                                 beginSpaceLeftButton: 12,
                                                 beginSpaceRightButton: 12)
        self.navigationbar = navigationBar
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)),
                                                  item: item,
                                                  count: 1)
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 22
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension StatusController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier,
                                                      for: indexPath) as! HomeFeedCollectionViewCell
        cell.viewModel = HomeFeedCellViewModel(status: self.status)
        cell.delegate = self
        return cell
    }
}

extension StatusController: HomeFeedCollectionViewCellDelegate {
    func didSelectNumberLikesButton(status: StatusModel) {
        let userLikedVc = LikesController(status: status)
        self.navigationController?.pushViewController(userLikedVc, animated: true)
    }
    
    func didSelectCommentButton(cell: HomeFeedCollectionViewCell, status: StatusModel) {
        let commentVC = CommentController(status: status, currentUser: currentUser)
        commentVC.delegate = cell.self
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func didSelectAvatar(status: StatusModel) {
        let profileVC = ProfileController(user: status.user, type: .other)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
