//
//  CommentViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import Foundation
import FirebaseAuth

class CommentViewModel {
    var status: StatusModel!
    var currentUser: UserModel!
    var comments: [CommentModel] = []
    
    var numberComments: Int {
        return comments.count
    }
    
    var avatarCurrentUserUrl: URL? {
        let url = URL(string: currentUser.profileImage ?? "")
        return url
    }
    
    var completionFetchComment: (() -> Void)?
    var completionUploadComment: (() -> Void)?
    
    func commentAtIndexPath(indexpath: IndexPath) -> CommentModel {
        return comments[indexpath.row]
    }
    
    func fetchComment() {
        CommentStatusService.shared.fetchCommentStatus(status: status) { comments in
            let sortedComments = comments.sorted{ $0.timestamp > $1.timestamp }
            self.comments = sortedComments
            self.completionFetchComment?()
        }
    }
    
    func uploadComment(caption: String) {
        CommentStatusService.shared.uploadCommentStatus(status: self.status,
                                                  caption: caption,
                                                  user: self.currentUser) { comment in
            self.comments.insert(comment, at: 0)
            self.completionFetchComment?()
        }
    }
}


