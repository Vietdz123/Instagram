//
//  InstagramConstant.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct UsersConstant {
    static let user = "users"
    static let username = "username"
    static let fullname = "fullname"
    static let profileImage = "profileImage"
    static let bio = "bio"
    static let link = "link"
    static let numberLikes = "numberLikes"
    static let numberComments = "numberComments"
    static let caption = "caption"
    static let timestamp = "timestamp"
    static let aspectRatio = "aspectRatio"
    static let uid = "uid"
    static let statusId = "statusId"
    static let comment = "comment"
    static let commentId = "commentId"
}


struct FirebaseRef {
    static let ref_user = Firestore.firestore().collection("users")
    static let ref_uploadStatus = Firestore.firestore().collection("status")
    static let ref_comments = Firestore.firestore().collection("comments")
    static let ref_userStatus = Firestore.firestore().collection("users-status")
    static let ref_followUser = Firestore.firestore().collection("follow-users")                //Check những ai đang follow 1 người
    static let ref_followingUser = Firestore.firestore().collection("following-users")          //Check 1 người đang following những ai
    static let ref_userLikeStatuses = Firestore.firestore().collection("user-likeStatuses")               // User đã like những Tus nào
    static let ref_tusLiked = Firestore.firestore().collection("tus-usersLiked")                  // Tus đã được những user nào like
    static let ref_tusCommented = Firestore.firestore().collection("tus-usersCommented")            // Tus đã được những user nào comment
}
