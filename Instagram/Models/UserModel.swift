//
//  Users.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit
import FirebaseAuth

struct UserRelationStats {
    var followers: Int
    var followings: Int
}

class UserModel {
    let email: String
    var username: String
    var fullname: String
    var uid: String
    var profileImage: String?
    var bio: String?
    var link: String?
    var isFollowed: Bool = true
    var stats: UserRelationStats = UserRelationStats(followers: 0, followings: 0)
    var numberStatus: Int = 0
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.link = dictionary["link"] as? String ?? ""
    }
}
