//
//  FollowerCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit
import FirebaseAuth

class FollowCellViewModel {
    let user: UserModel
    let type: HeaderFollowViewType
    let fromType: ProfileControllerType
    
    var avatarUrl: URL? {
        let url = URL(string: user.profileImage ?? "")
        return url
    }
    
    var username: String? {
        if fromType == .other {
            return user.username
        }
        
        if type == .follower {
            if hasFollowed {
                return user.username
            }
            return "\(user.username)  •  "
        }
        
        return user.username
    }
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == user.uid
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var hasFollowed: Bool {
        return user.isFollowed
    }
    
    init(user: UserModel, type: HeaderFollowViewType, fromType: ProfileControllerType) {
        self.user = user
        self.type = type
        self.fromType = fromType
    }
    
    
}
