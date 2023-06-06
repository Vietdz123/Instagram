//
//  CommentCollectionViewCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import Foundation

class CommentCollectionViewCellViewModel {
    let comment: CommentModel
    
    var dateCommentString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: comment.timestamp, to: now) ?? "1m"
    }
    
    var user: UserModel {
        return comment.user
    }
    
    var contentComment: String {
        return comment.content
    }
    
    var username: String {
        return comment.user.username
    }
    
    var avatarImageUrl: URL? {
        let url = URL(string: self.comment.user.profileImage ?? "")
        return url
    }
    
    init(comment: CommentModel) {
        self.comment = comment
    }
    
}
