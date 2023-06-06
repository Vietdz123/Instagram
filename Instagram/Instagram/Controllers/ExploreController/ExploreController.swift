//
//  SearchController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit


class ExploreController: UIViewController {
    //MARK: - Properties
    let viewModel = ExploreViewModel()
    let searchBar = CustomSearchBarView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchTableView = UITableView(frame: .zero, style: .plain)
    let refreshControl = UIRefreshControl()
    let loadingIndicator = UIActivityIndicatorView()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureUI()
        configureProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    deinit {
        print("DEBUG: ExploreController deinit")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(searchTableView)
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    
    func configureProperties() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(ExploreCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreCollectionViewCell.identifier)
        collectionView.refreshControl = refreshControl
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(ExploreSearchBarTableViewCell.self,
                                 forCellReuseIdentifier: ExploreSearchBarTableViewCell.identifier)
        searchTableView.alpha = 0
        searchTableView.backgroundColor = .systemBackground
        searchTableView.separatorColor = .clear
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 3))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 3)
        group.interItemSpacing = .fixed(1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func fetchData() {
        loadingIndicator.startAnimating()
        viewModel.fetchOtherUsers()
        viewModel.completion = { [weak self] in
            self?.collectionView.reloadData()
            self?.loadingIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }
    
    //MARK: - Selectors
    @objc func handleRefreshControl() {
        self.viewModel.reloadData()
    }

    
}
//MARK: - delegate
extension ExploreController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberStatuses
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.identifier,
                                                      for: indexPath) as! ExploreCollectionViewCell
        
        cell.imageURL = viewModel.imageUrlAtIndexpath(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = viewModel.currentUser else {return}
        let status = viewModel.statusAtIndexPath(indexPath: indexPath)
        let statusDetailVC = StatusController(status: status, user: user)
        self.navigationController?.pushViewController(statusDetailVC, animated: true)
    }
}

extension ExploreController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberUserFounded
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreSearchBarTableViewCell.identifier,
                                                 for: indexPath) as! ExploreSearchBarTableViewCell
        cell.user = viewModel.userAtIndexPath(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = ProfileController(user: viewModel.userAtIndexPath(indexPath: indexPath), type: .other)

        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension ExploreController: CustomSearchBarDelegate {    
    func didChangedSearchTextFiled(textField: UITextField) {
        guard let name = textField.text else {return}
        viewModel.searchUsers(name: name)
        searchTableView.reloadData()
    }
    
    func didBeginEdittingSearchField(textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.searchTableView.alpha = 1
        }
    }
    
    func didSelectCancelButton() {
        UIView.animate(withDuration: 0.25) {
            self.searchTableView.alpha = 0
        }
    }
    
}
