//
//  ReactionUsersController.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit

class LikesController: UIViewController {
    //MARK: - Properties
    let refreshControl = UIRefreshControl()
    let loadingIndicator = UIActivityIndicatorView()
    let viewModel: LikesViewModel
    let tableView = UITableView(frame: .zero, style: .plain)
    var navigationbar: NavigationCustomView!
    let searchBar = CustomSearchBarView(ishiddenCancelButton: true)
    var indexPathSelected: IndexPath?

    //MARK: - View Lifecycle
    init(status: StatusModel) {
        self.viewModel = LikesViewModel(status: status)
        super.init(nibName: nil, bundle: nil)
        self.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: LikesController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
    }
    
    //MARK: - Helpers
    func fetchData() {
        viewModel.fetchData()
        viewModel.completionFecthData = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    func configureUI() {
        self.setupNavigationBar()
        self.view.addSubview(navigationbar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.view.addSubview(loadingIndicator)
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        loadingIndicator.center = view.center
        
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 45),
            
            searchBar.topAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 6),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureProperties() {
        loadingIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UserLikedTableViewCell.self,
                                 forCellReuseIdentifier: UserLikedTableViewCell.identifier)
        tableView.separatorStyle = .none
        let geture = UITapGestureRecognizer(target: self,
                                            action: #selector(didEndSearchUser))
        geture.cancelsTouchesInView = false
        view.addGestureRecognizer(geture)
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

        view.isUserInteractionEnabled = true
        searchBar.delegate = self
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "arrow-left"),
                                                       sizeImage: CGSize(width: 26, height: 26)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
                                                   
        self.navigationbar = NavigationCustomView(centerTitle: "Likes",
                                              attributeLeftButtons: [attributeFirstLeftButton],
                                              attributeRightBarButtons: [],
                                              beginSpaceLeftButton: 15)
    }
    
    //MARK: - Selectors
    @objc func didEndSearchUser() {
        self.searchBar.forceEndSearching()
    }
    
    @objc func handleRefreshControl() {
        self.viewModel.reloadData()
    }
    
}
//MARK: - delegate
extension LikesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserLikedTableViewCell.identifier,
                                                 for: indexPath) as! UserLikedTableViewCell
        cell.viewModel = LikesTableViewCellViewModel(user: viewModel.userAtIndexPath(indexPath: indexPath))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPathSelected = indexPath
        let profileVc = ProfileController(user: viewModel.userAtIndexPath(indexPath: indexPath), type: .other)
        profileVc.headerViewController.delegate = self
        navigationController?.pushViewController(profileVc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)

    }
}

extension LikesController: HeaderProfileDelegate {
    func didSelectFollowButtonTap(hasFollowed: Bool) {
        guard let indexPath = self.indexPathSelected else {
            return}
        let cell = tableView.cellForRow(at: indexPath) as! UserLikedTableViewCell
        cell.updateFollowButton(hasFollowed: hasFollowed)
    }
}

extension LikesController: CustomSearchBarDelegate {
    func didChangedSearchTextFiled(textField: UITextField) {
        viewModel.searchUser(name: textField.text ?? "")
    }
        
    func didEndSearching() {
        viewModel.reloadData()
    }
}

extension LikesController: UserLikedTableViewDelegate {
    func didTapFollowButton(cell: UserLikedTableViewCell, user: UserModel) {
        if user.isFollowed {
            self.viewModel.unfollowUser(user: user)
            user.isFollowed = false
            cell.updateFollowButton()
        } else {
            self.viewModel.followUser(user: user)
            user.isFollowed = true
            cell.updateFollowButton()
        }
    }
    
}
