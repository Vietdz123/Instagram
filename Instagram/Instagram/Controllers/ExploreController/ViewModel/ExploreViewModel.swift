//
//  ExploreViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 24/05/2023.
//

import UIKit
import FirebaseAuth

class ExploreViewModel {
    private var users: [UserModel] = []
    var foundedUsers: [UserModel] = []
    var statuses: [StatusModel] = []
    var completion: (() -> Void)?
    var currentUser: UserModel?
    
    var numberUserFounded: Int {
        return foundedUsers.count
    }
    
    func fetchOtherUsers() {
        UserService.shared.fetchOtherUsers { users in
            self.users = users
            self.fetchStatuses()
        }
        
        self.fetchCurrentUser()
    }
    
    func reloadData() {
        self.fetchOtherUsers()
    }
    
    var numberStatuses: Int {
        return statuses.count
    }
    
    func statusAtIndexPath(indexPath: IndexPath) -> StatusModel {
        return statuses[indexPath.row]
    }
    
    func userAtIndexPath(indexPath: IndexPath) -> UserModel {
        return foundedUsers[indexPath.row]
    }
    
    func imageUrlAtIndexpath(indexPath: IndexPath) -> URL? {
        let url = URL(string: statuses[indexPath.row].postImage.imageURL)
        return url
    }
    
    private func fetchStatuses() {
        var numberUser = 0
        var tempStatues: [StatusModel] = []
        for user in users {
            StatusService.shared.fetchStatusUser(uid: user.uid) { userStatues in
                numberUser += 1
                tempStatues.append(contentsOf: userStatues)
                if numberUser == self.users.count {
                    self.statuses = tempStatues
                    self.statuses.shuffle()
                    self.completion?()
                }
            }
        }
    }
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        UserService.shared.fetchUser(uid: uid) { user in
            self.currentUser = user
        }
    }
    
    func searchUsers(name: String)  {
        var expectedUsers: [UserModel] = []
        for user in users {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
            }
        }
        
        self.foundedUsers = expectedUsers
    }
}
