//
//  CommentStatusService.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class CommentStatusService {
    static let shared = CommentStatusService()
    private let db = Firestore.firestore()
    
    func uploadCommentStatus(status: StatusModel,
                       caption: String,
                       user: UserModel,
                       completion: @escaping(CommentModel) -> Void) {
        let statusId = status.statusId
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let timestamp = Double(NSDate().timeIntervalSince1970)
        
        let dictionary: [String: Any] = [UsersConstant.uid: uid,
                                         UsersConstant.comment: caption,
                                         UsersConstant.timestamp: timestamp,
                                         UsersConstant.statusId: statusId]
        
        
        let commentId = NSUUID().uuidString
        FirebaseRef.ref_comments.document(commentId).setData(dictionary) { _ in
            FirebaseRef.ref_tusCommented.document(statusId).setData([commentId: "1"], merge: true) { _ in
                let comment = CommentModel(dictionary: dictionary, user: user)
                completion(comment)
            }
        }
    }
    
    
    private func fetchComment(commentId: String, completion: @escaping (CommentModel?) -> Void) {
        let queue = DispatchQueue(label: "Queue")
        queue.async {
            FirebaseRef.ref_comments.document(commentId).getDocument { documentSnap, _ in
                guard let dictionary = documentSnap?.data() else {
                    completion(nil)
                    return
                }
                guard let userId = dictionary[UsersConstant.uid] as? String else {
                    completion(nil)
                    return
                }
                
                UserService.shared.fetchUser(uid: userId) { user in
                    let comment = CommentModel(dictionary: dictionary, user: user)
                    completion(comment)
                }
            }
        }
    }
    
    
    func fetchCommentStatus(status: StatusModel,
                            completion: @escaping([CommentModel]) -> Void) {
        var comments: [CommentModel] = []
        let statusId = status.statusId
        var numberComments = 0
        
        FirebaseRef.ref_tusCommented.document(statusId).getDocument{ documentSnap, _ in
            guard let documents = documentSnap?.data() else {
                completion([])
                return
            }
            
            for document in documents {
                let commentId = document.key
                self.fetchComment(commentId: commentId) { comment in
                    numberComments += 1
                    guard let comment = comment else {
                        if numberComments == comments.count - 1 {
                            DispatchQueue.main.async {
                                completion(comments)
                            }
                        }
                        return
                    }
                    
                    comments.append(comment)
                    if numberComments == comments.count {
                        DispatchQueue.main.async {
                            completion(comments)
                        }
                    }
                }
            }
        }
    }
    
    func fetchNumberUsersCommented(status: StatusModel,
                                   completion: @escaping (Int) -> Void) {
        let statusId = status.statusId
        let queue = DispatchQueue(label: "queue")
        queue.async {
            FirebaseRef.ref_tusCommented.document(statusId).getDocument { documentSnap, error in
                if let _ = error {
                    completion(0)
                    return
                }
                
                guard let documentData = documentSnap?.data() else {
                    completion(0)
                    return
                }
                completion(documentData.count)
            }
        }
    }

}
