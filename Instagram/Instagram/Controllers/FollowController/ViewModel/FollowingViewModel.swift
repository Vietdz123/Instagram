//
//  FollowingViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit

class FollowingViewModel {
    var currentUser: UserModel
    var user: UserModel
    var followingUsers: [UserModel] = []
    private var tempUsers: [UserModel] = []
    let fromType: ProfileControllerType
    
    var completionFecthData: (() -> Void)?
    var duringReloadData: (() -> Void)?
    var completionUpdateFollowUser: (() -> Void)?
    
    func userAtIndexPath(indexPath: IndexPath) -> UserModel {
        return followingUsers[indexPath.row]
    }
    
    var numberUsers: Int {
        return followingUsers.count
    }
    
    func searchUser(name: String) {
        var expectedUsers: [UserModel] = []
        self.tempUsers = followingUsers

        for user in tempUsers {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
            }
        }
        
        self.followingUsers = expectedUsers
        self.completionFecthData?()
    }
    
    func fetchData() {
        var numberUsers = 0

        UserService.shared.fetchFollowingUsers(uid: user.uid) { users in
            self.followingUsers = []
            self.followingUsers = users.sorted { $0.username > $1.username }
            self.completionFecthData?()
            for user in users {
                UserService.shared.hasFollowedUser(uid: user.uid) { hasFollowed in
                    user.isFollowed = hasFollowed
                    numberUsers += 1
                    if numberUsers == users.count {
                        self.completionFecthData?()
                        self.completionUpdateFollowUser?()
                    }
                }
            }
        }
    }
    
    func followUser(user: UserModel) {
        for i in 0..<followingUsers.count {
            if followingUsers[i].uid == user.uid {
                self.followingUsers[i].isFollowed = true
                self.user.stats.followings += 1
                UserService.shared.followUser(uid: user.uid) {
                    self.completionUpdateFollowUser?()
                }
                return
            }
        }
    }
    
    func unfollowUser(user: UserModel) {
        for i in 0..<followingUsers.count {
            if followingUsers[i].uid == user.uid {
                self.followingUsers[i].isFollowed = false
                self.user.stats.followings -= 1
                UserService.shared.unfollowUser(uid: user.uid) {
                    self.completionUpdateFollowUser?()
                }
                return
            }
        }
    }
    
    func reloadData() {
        self.fetchData()
    }
    
    init(user: UserModel, currentUser: UserModel, fromType: ProfileControllerType) {
        self.user = user
        self.currentUser = currentUser
        self.fromType = fromType
    }
    
    
}
