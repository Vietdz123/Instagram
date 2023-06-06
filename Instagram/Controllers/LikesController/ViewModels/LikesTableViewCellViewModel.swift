//
//  UserLikedCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit
 
class LikesTableViewCellViewModel {
    var user: UserModel
    
    var avatarImageUrl: URL? {
        return URL(string: self.user.profileImage ?? "")
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var hasFollowed: Bool {
        return user.isFollowed
    }
    

    
    var completion: (() -> Void)?
    
    init(user: UserModel) {
        self.user = user
    }
    
}
