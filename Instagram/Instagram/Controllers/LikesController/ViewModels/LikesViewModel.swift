//
//  File.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit

class LikesViewModel {
    let status: StatusModel
    var users: [UserModel] = []
    private var tempUsers: [UserModel] = []
    
    var completionFecthData: (() -> Void)?
    var duringReloadData: (() -> Void)?
    
    func userAtIndexPath(indexPath: IndexPath) -> UserModel {
        return users[indexPath.row]
    }
    
    var numberUsers: Int {
        return users.count
    }
    
    func searchUser(name: String) {
        var expectedUsers: [UserModel] = []
        self.tempUsers = users

        for user in tempUsers {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
            }
        }
        
        self.users = expectedUsers
        self.completionFecthData?()
    }
    
    func fetchData() {
        //Reset to O making animation like instagram
        self.users = []
        self.completionFecthData?()
        var numberUser = 0
        StatusService.shared.fetchUsersLikeStatus(status: status) { users in
            users.forEach { user in
                UserService.shared.hasFollowedUser(uid: user.uid) { isFollowed in
                    user.isFollowed = isFollowed
                    self.users.append(user)
                    numberUser += 1
                    if numberUser == users.count {
                        self.completionFecthData?()
                    }
                }
            }
        }
    }
    
    func reloadData() {
        var numberUser = 0
        var tempUsers: [UserModel] = []
        StatusService.shared.fetchUsersLikeStatus(status: status) { users in
            self.duringReloadData?()
            users.forEach { user in
                UserService.shared.hasFollowedUser(uid: user.uid) { isFollowed in
                    user.isFollowed = isFollowed
                    tempUsers.append(user)
                    numberUser += 1
                    if numberUser == users.count {
                        DispatchQueue.main.async {
                            self.users = tempUsers
                            self.completionFecthData?()
                        }
                    }
                }
            }
        }
    }
    
    func followUser(user: UserModel) {
        for i in 0..<users.count {
            if users[i].uid == user.uid {
                UserService.shared.followUser(uid: user.uid) {
                    self.users[i].isFollowed = true
                }
                return
            }
        }
    }
    
    func unfollowUser(user: UserModel) {
        for i in 0..<users.count {
            if users[i].uid == user.uid {
                UserService.shared.unfollowUser(uid: user.uid) {
                    self.users[i].isFollowed = false
                }
                return
            }
        }
    }
    
    init(status: StatusModel) {
        self.status = status
    }
}
