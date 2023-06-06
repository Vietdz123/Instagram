//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class ProfileViewModel {
    var user: UserModel?
    var currentUser: UserModel?
    
    func fetchDataForCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            self.currentUser = user
            self.completionFetchMainInfo?()
            UserService.shared.fetchUserRelationStats(uid: uid) { relationStats in
                self.user?.stats = relationStats
                StatusService.shared.fetchStatusUser(uid: uid) { statuses in
                    self.user?.numberStatus = statuses.count
                    self.completionFetchSubInfo?()
                }
            }
        }
    }
    
    var completionFetchMainInfo: (() -> Void)?
    var completionFetchSubInfo: (() -> Void)?
    
    var isFollowed: Bool {
        return user?.isFollowed == true
    }
    
    func fetchDataForAnotherUser() {
        guard let user = user else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.currentUser = user
        }

        UserService.shared.hasFollowedUser(uid: user.uid) { isFollowed in
            self.user?.isFollowed = isFollowed
            self.completionFetchMainInfo?()
            UserService.shared.fetchUserRelationStats(uid: user.uid) { relationStats in
                self.user?.stats = relationStats
                StatusService.shared.fetchStatusUser(uid: user.uid) { statuses in
                    self.user?.numberStatus = statuses.count
                    self.completionFetchSubInfo?()
                }
            }
        }
    }
    
    func followUser() {
        guard let user = user else {
            return
        }

        UserService.shared.followUser(uid: user.uid) {
            self.user?.isFollowed = true
        }
    }
    
    func unfollowUser() {
        guard let user = user else {
            return
        }

        UserService.shared.unfollowUser(uid: user.uid) {
            self.user?.isFollowed = false
        }
    }
    
    func referchData() {
        guard let user = user else {
            return
        }

        UserService.shared.fetchUser(uid: user.uid) { user in
            self.user = user
            self.fetchDataForAnotherUser()
        }
    }
}
