//
//  Comment.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import UIKit

struct CommentModel {
    let content: String
    let statusID: String
    let user: UserModel
    var timestamp: Date!
    
    init(dictionary: [String: Any], user: UserModel) {
        self.content = dictionary[UsersConstant.comment] as? String ?? ""
        self.statusID = dictionary[UsersConstant.statusId] as? String ?? ""
        self.user = user
        
        if let timestamp = dictionary[UsersConstant.timestamp] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
