//
//  FollowController.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import Foundation
import UIKit

enum BeginFollowController: Int {
    case follower = 0
    case Following = 1
}

class FollowController: UIViewController {
    //MARK: - Properties
    var navigationbar: NavigationCustomView!
    let beginPage: BeginFollowController
    let user: UserModel
    let currentUser: UserModel
    var followersController: BottomFollowersController!
    var followingController: BottomFollowingController!
    var bottomTapTripController: BottomTapTripController!
    let fromType: ProfileControllerType

    //MARK: - View Lifecycle
    init(user: UserModel,
         currentUser: UserModel,
         begin: BeginFollowController,
         type: ProfileControllerType) {
        self.beginPage = begin
        self.user = user
        self.currentUser = currentUser
        self.fromType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true


    }

    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        self.setupNavigationBar()
        view.addSubview(navigationbar)
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        let configureTabBar = ConfigureTabBar(backgroundColor: .systemBackground,
                                              dividerColor: .black,
                                              selectedBarColor: .label,
                                              notSelectedBarColor: .systemGray,
                                              selectedBackgroundColor: .systemBackground)
                                              
        followersController = BottomFollowersController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "\(user.stats.followers) people followers")))
        followingController = BottomFollowingController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "\(user.stats.followings) people following")))

        
        bottomTapTripController  = BottomTapTripController(controllers: [followersController,
                                                                  followingController],
                                                    configureTapBar: configureTabBar,
                                                    beginPage: self.beginPage.rawValue)
        followersController.viewModel = FollowerViewModel(user: self.user, currentUser: self.currentUser, fromType: fromType)
        followingController.viewModel = FollowingViewModel(user: self.user, currentUser: self.currentUser, fromType: fromType)
        followingController.delegate = self
        followersController.delegate = self
                                                                      
        addChild(bottomTapTripController)
        view.addSubview(bottomTapTripController.view)
        didMove(toParent: self)
        guard let viewBottom = bottomTapTripController.view else {return}
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 40),
            
            viewBottom.topAnchor.constraint(equalTo: navigationbar.bottomAnchor),
            viewBottom.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewBottom.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutIfNeeded()

    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "arrow-left"),
                                                       sizeImage: CGSize(width: 26, height: 26)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
                                                
        self.navigationbar = NavigationCustomView(centerTitle: user.username,
                                                  attributeLeftButtons: [attributeFirstLeftButton],
                                                  attributeRightBarButtons: [],
                                                  isHiddenDivider: true,
                                                  beginSpaceLeftButton: 15)
    }

    //MARK: - Selectors

}
//MARK: - delegate
extension FollowController: BottomFollowDelegate {
    func didSelectFollowButton(user: UserModel) {
        if self.fromType == .other {return}
        self.followingController.titleBottom.titleString.title = "\(user.stats.followings) people followings"
        self.bottomTapTripController.reloadNavigationBar()
    }
    
    func didTapRemoveButton(user: UserModel) {
        if self.fromType == .other {return}
        self.followersController.titleBottom.titleString.title = "\(user.stats.followers) people followers"
        self.bottomTapTripController.reloadNavigationBar()
    }
    
    func didSelectUser(user: UserModel) {
        let profileVc = ProfileController(user: user, type: .other)
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
    
}
