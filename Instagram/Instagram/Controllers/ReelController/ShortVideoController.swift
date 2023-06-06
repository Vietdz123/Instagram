//
//  ShortVideoController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class ShortVideoController: UIViewController {
    //MARK: - Properties
    
    
    //MARK: - View Lifecycle
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
        view.backgroundColor = .systemCyan
        
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar

        let followersController = BottomFollowersController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "48 people followers")))
        let followingController = BottomFollowingController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "56 people following")))
        let bottomTapTrip = BottomTapTripController(controllers: [followersController, followingController
                                                                      ])
        addChild(bottomTapTrip)
        view.addSubview(bottomTapTrip.view)
        didMove(toParent: self)
        
        guard let viewBottom = bottomTapTrip.view else {return}
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewBottom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewBottom.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewBottom.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }
    
    //MARK: - Selectors
    @objc func hanldeCancelButtonTapped() {
        

    }
}
//MARK: - delegate
