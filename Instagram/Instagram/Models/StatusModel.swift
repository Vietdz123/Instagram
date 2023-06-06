//
//  InstaStatus.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import UIKit

struct PostImage {
    let imageURL: String
    let aspectRatio: Float  /// width / height
}

struct StatusModel {
    let user: UserModel
    let caption: String
    let postImage: PostImage
    var timeStamp: Date!
    let statusId: String
    var numberLikes: Int = 0
    var numberComments: Int
    var likedStatus: Bool = false
    
    init(user: UserModel, statusId: String, dictionary: [String: Any]) {
        self.user = user
        self.statusId = statusId
        self.caption = dictionary[UsersConstant.caption] as? String ?? ""
        self.numberComments = dictionary[UsersConstant.numberComments] as? Int ?? 0
        
        if let timestamp = dictionary[UsersConstant.timestamp] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        let imageURL = dictionary[UsersConstant.profileImage] as? String ?? ""
        let aspectRatio = dictionary[UsersConstant.aspectRatio] as? Float ?? 0.0
        self.postImage = PostImage(imageURL: imageURL, aspectRatio: aspectRatio)
    }
}
