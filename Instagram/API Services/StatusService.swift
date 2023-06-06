//
//  StatusService.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class StatusService {
    static let shared = StatusService()
    private let db = Firestore.firestore()
    
    
    func uploadStatus(image: UIImage?,
                      uid: String,
                      status: String?,
                      completion: @escaping(Error?) -> Void) {
        guard let image = image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        
        let aspectRatio = Float(image.size.width) / Float(image.size.height)
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion(error)
            }
            
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                let dictionary: [String: Any] = [UsersConstant.profileImage: profileImageUrl,
                                                 UsersConstant.timestamp: timestamp,
                                                 UsersConstant.uid: uid,
                                                 UsersConstant.aspectRatio: aspectRatio,
                                                 UsersConstant.caption: status ?? ""]
                
                let statusID = NSUUID().uuidString
                FirebaseRef.ref_uploadStatus.document(statusID).setData(dictionary) { _ in
                    FirebaseRef.ref_userStatus.document(uid).setData([statusID: "1"], merge: true) { _ in
                        completion(error)
                    }
                }
            }
        }
    }
    
    func fetchStatusUser(uid: String,
                         completion: @escaping([StatusModel]) -> Void) {
        FirebaseRef.ref_userStatus.document(uid).getDocument { documentSnap, error in
            guard let documentSnap = documentSnap else {
                completion([])
                return
            }
            guard let dictionary = documentSnap.data() as? [String: String] else {
                completion([])
                return
            }
            
            var statuses: [StatusModel] = []
            let dispathGroup = DispatchGroup()
            
            for document in dictionary {
                let statusID = document.key
                dispathGroup.enter()
                FirebaseRef.ref_uploadStatus.document(statusID).getDocument { documentSnap, _ in
                    guard let documentSnap = documentSnap else { return }
                    guard let dictionary = documentSnap.data()  else {return}
                    guard let uid = dictionary[UsersConstant.uid] as? String else {return}
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        let status = StatusModel(user: user, statusId: statusID, dictionary: dictionary)
                        statuses.append(status)
                        dispathGroup.leave()
                    }
                }
            }
            
            dispathGroup.notify(queue: .main) {
                let sortedStatus = statuses.sorted { $0.timeStamp > $1.timeStamp}
                completion(sortedStatus)
            }
        }
    }
    
    func fetchStatusUserAndFollowing(users: [UserModel],
                                     completion: @escaping([StatusModel]) -> Void) {
        var numberUsers = 0
        var statues: [StatusModel] = []

        for user in users {
            self.fetchStatusUser(uid: user.uid) { userStatuses in
                statues.append(contentsOf: userStatuses)
                numberUsers += 1
                
                if numberUsers == users.count {
                    statues = statues.shuffled()  //Random statues
                    completion(statues)
                }
             }
        }
    }
    
    func likeStatus(status: StatusModel,
                    completion: @escaping() -> Void) {
        let statusId = status.statusId
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let queue = DispatchQueue(label: "Queue")
        queue.async {
            FirebaseRef.ref_userLikeStatuses.document(currentUid).setData([statusId: "1"], merge: true) { _ in
                FirebaseRef.ref_tusLiked.document(statusId).setData([currentUid: "1"], merge: true) { _ in
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }

    }
    
    func unlikeStatus(status: StatusModel,
                    completion: @escaping() -> Void) {
        let statusId = status.statusId
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let queue = DispatchQueue(label: "Queue")
        queue.async {
            FirebaseRef.ref_userLikeStatuses.document(currentUid).updateData([statusId: FieldValue.delete()]) { _ in
                FirebaseRef.ref_tusLiked.document(statusId).updateData([currentUid: FieldValue.delete()]) { _ in
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
 
    }
    
    func hasUserLikedTus(status: StatusModel,
                         uid: String,
                         completion: @escaping(Bool) -> Void) {
        let queue = DispatchQueue(label: "Queue")
        let statusId = status.statusId
        queue.async {
            FirebaseRef.ref_userLikeStatuses.document(uid).getDocument { documentSnap, _ in
                guard let documentData = documentSnap?.data() else {
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    if documentData[statusId] == nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }

        }
    }
    
    func fetchNumberUsersLikedStatus(status: StatusModel,
                                     completion: @escaping(Int) -> Void) {
        let statusId = status.statusId
        let queue = DispatchQueue(label: "Queue")
        queue.async {
            FirebaseRef.ref_tusLiked.document(statusId).getDocument { documentSnap, _ in
                guard let data = documentSnap?.data() else {
                    completion(0)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(data.count)
                }
            }
        }
    }
    
    func fetchUsersLikeStatus(status: StatusModel,
                              completion: @escaping([UserModel]) -> Void) {
        var users: [UserModel] = []
        let statusId = status.statusId
        let queue = DispatchQueue(label: "Queue")
        var numberUser = 0
        queue.async {
            FirebaseRef.ref_tusLiked.document(statusId).getDocument { documentSnap, _ in
                guard let documents = documentSnap?.data() else {
                    completion(users)
                    return
                }
                
                for document in documents {
                    let uid = document.key
                    UserService.shared.fetchUser(uid: uid) { user in
                        users.append(user)
                        numberUser += 1
                        
                        if numberUser == documents.count {
                            DispatchQueue.main.async {
                                completion(users)
                            }
                        }
                    }
                }
            }
        }
    }

}
