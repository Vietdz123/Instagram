//
//  HomeViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class HomeViewModel {
    var currentUser: UserModel!
    var users: [UserModel] = []
    var statuses: [StatusModel] = []

    func fetchDataUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.currentUser = user
            self.users.append(user)
            self.fetchFollowingUsers()
        }
    }
    
    var completion: (() -> Void)?
    
    var numberStatuses: Int {
        return statuses.count
    }
    
    func statusAtIndexPath(indexPath: IndexPath) -> StatusModel {
        return statuses[indexPath.row]
    }
    
    private func fetchFollowingUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
            
        }
        UserService.shared.fetchFollowingUsers(uid: uid) { users in
            self.users = [self.currentUser]
            self.users.append(contentsOf: users)
            self.fetchStatuses()
        }
    }
    
    private func fetchStatuses() {
        StatusService.shared.fetchStatusUserAndFollowing(users: self.users) { statuses in
            self.statuses = []
            self.statuses.append(contentsOf: statuses)
            self.completion?()
        }
    }
    
    func referchData() {
        self.fetchFollowingUsers()
    }
    
}
