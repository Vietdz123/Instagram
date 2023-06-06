//
//  FollowerViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit

class FollowerViewModel {
    var user: UserModel
    var currentUser: UserModel
    var followerUsers: [UserModel] = []
    private var tempUsers: [UserModel] = []
    let fromType: ProfileControllerType
    
    var completionFecthData: (() -> Void)?
    var duringReloadData: (() -> Void)?
    var completionUpdateFollowUser: (() -> Void)?
    var completionRemoveFollower: (() -> Void)?
    
    func userAtIndexPath(indexPath: IndexPath) -> UserModel {
        return followerUsers[indexPath.row]
    }
    
    var numberUsers: Int {
        return followerUsers.count
    }
    
    func getIndexPath(user: UserModel) -> IndexPath? {
        for i in 0..<followerUsers.count {
            if followerUsers[i].uid == user.uid {
                return IndexPath(row: i, section: 0)
            }
        }
        return nil
    }
    
    func searchUser(name: String) {
        var expectedUsers: [UserModel] = []
        self.tempUsers = followerUsers

        for user in tempUsers {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
            }
        }
        
        self.followerUsers = expectedUsers
        self.completionFecthData?()
    }
    
    func fetchData() {
        var numberUsers = 0
        self.followerUsers = []
        UserService.shared.fetchFollowerUsers(uid: user.uid) { users in
            self.followerUsers = users.sorted { $0.username > $1.username }
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
    
    func reloadData() {
        self.fetchData()
    }
    
    func followUser(user: UserModel) {
        for i in 0..<followerUsers.count {
            if followerUsers[i].uid == user.uid {
                self.followerUsers[i].isFollowed = true
                self.user.stats.followings += 1
                UserService.shared.followUser(uid: user.uid) {
                    self.completionUpdateFollowUser?()
                }
                return
            }
        }
    }
    
    func unfollowUser(user: UserModel) {
        for i in 0..<followerUsers.count {
            if followerUsers[i].uid == user.uid {
                self.followerUsers[i].isFollowed = false
                self.user.stats.followings -= 1
                UserService.shared.unfollowUser(uid: user.uid) {
                    self.completionUpdateFollowUser?()
                }
                return
            }
        }
    }
    
    func removeFollowerUser(user: UserModel) {
        for i in 0..<followerUsers.count {
            if followerUsers[i].uid == user.uid {
                self.user.stats.followers -= 1
                UserService.shared.removeFollower(uid: user.uid) {
                    self.completionRemoveFollower?()
                    self.followerUsers.remove(at: i)

                }
                return
            }
        }
    }
    
    init(user: UserModel, currentUser: UserModel, fromType: ProfileControllerType) {
        self.user = user
        self.currentUser = currentUser
        self.fromType = fromType
    }
    
    
}
