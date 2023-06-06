//
//  BottomFollowersController.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit

class BottomFollowersController: BottomController {
    //MARK: - Properties
    let refreshControl = UIRefreshControl()
    let loadingIndicator = UIActivityIndicatorView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: BottomFollowDelegate?
    
    var viewModel: FollowerViewModel? {
        didSet {
            self.fetchData()
        }
    }
    
    override var bottomTabTripCollectionView: UICollectionView {
        return self.collectionView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - Helpers
    func fetchData() {
        self.loadingIndicator.startAnimating()
        self.viewModel?.fetchData()
        self.viewModel?.completionFecthData = { [weak self] in
            self?.collectionView.reloadData()
            self?.loadingIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func configureUI() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(BottomFollowerCollectionViewCell.self,
                                forCellWithReuseIdentifier: BottomFollowerCollectionViewCell.identifier)
        collectionView.register(HeaderFollowView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderFollowView.identifier)
        collectionView.layoutIfNeeded()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.refreshControl = refreshControl
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section = ComposionalLayout.createSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Selectors
    @objc func handleRefreshControl() {
        viewModel?.reloadData()
    }
    
}
//MARK: - delegate
extension BottomFollowersController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberUsers ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomFollowerCollectionViewCell.identifier, for: indexPath) as! BottomFollowerCollectionViewCell
        guard let viewModel = viewModel else {return cell}
        cell.viewModel = FollowCellViewModel(user: viewModel.userAtIndexPath(indexPath: indexPath), type: .follower, fromType: viewModel.fromType)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}

        self.delegate?.didSelectUser(user: viewModel.userAtIndexPath(indexPath: indexPath))
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: HeaderFollowView.identifier,
                                                                     for: indexPath) as! HeaderFollowView
        header.type = .follower
        return header
    }
}

extension BottomFollowersController: BottomFollowerCellDelehgate {
    func didSelectFollowButton(cell: BottomFollowerCollectionViewCell, user: UserModel) {
        viewModel?.completionUpdateFollowUser = {
            cell.updateFollowButtonAfterTapped()
        }
        
        if user.isFollowed {
            cell.viewModel?.user.isFollowed = false
            cell.updateFollowButtonAfterTapped()
            viewModel?.unfollowUser(user: user)

        } else {
            cell.viewModel?.user.isFollowed = true
            cell.updateFollowButtonAfterTapped()
            viewModel?.followUser(user: user)
        }
        
    }
    
    func didSelectRemmoveButton(cell: BottomFollowerCollectionViewCell, user: UserModel) {
        viewModel?.completionRemoveFollower = {
            guard let indexPath = self.viewModel?.getIndexPath(user: user) else {return}
            self.collectionView.deleteItems(at: [indexPath])
            self.delegate?.didTapRemoveButton(user: self.viewModel!.user)
        }
        viewModel?.removeFollowerUser(user: user)

    }
    
    
    
}


