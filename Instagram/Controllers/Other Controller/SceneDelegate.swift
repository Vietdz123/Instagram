//
//  SceneDelegate.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
            guard let window = self.window else {
                return
            }
            
            window.rootViewController = vc
            window.alpha = 0.3
            UIView.transition(with: window, duration: 0.5, animations: {
                window.alpha = 1
            })
        }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = (Auth.auth().currentUser != nil) ? MainTabBarController() : LoginController()
        window.makeKeyAndVisible()
    }

}

