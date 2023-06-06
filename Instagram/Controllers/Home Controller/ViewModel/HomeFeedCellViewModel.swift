//
//  HomeFeedCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class HomeFeedCellViewModel {
    var status: StatusModel
    
    var attributedCaptionLabel:  NSAttributedString {
        let attributes = NSMutableAttributedString(string: status.user.username,
                                                   attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                                                .foregroundColor: UIColor.label])
        attributes.append(NSAttributedString(string: " \(String(describing: status.caption))",
                                             attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                          .foregroundColor: UIColor.label]))
        return attributes
    }
    
    var haveCaption: Bool {
        return status.caption != ""
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: status.timeStamp)
    }
    
    var avatarURL: URL? {
        URL(string: status.user.profileImage ?? "")
    }
    
    var photoURL: URL? {
        URL(string: status.postImage.imageURL)
    }
    
    var ratioImage: CGFloat {
        CGFloat(1.0 /  status.postImage.aspectRatio)
    }
    
    var likedStatus: Bool {
        return status.likedStatus
    }
    
    var username: String {
        return status.user.username
    }
    
    var shouldHiddentLikesBotton: Bool {
        return numberLikesInt == 0
    }
    
    var numberLikesString: String {
        let numberLikes = status.numberLikes
        if numberLikes <= 1 {
            return "\(numberLikes) like"
        }
        return "\(status.numberLikes) likes"
    }
    
    var numberLikesInt: Int {
        return status.numberLikes
    }
    
    var isHiddedNumberLike: Bool {
        return status.numberLikes == 0
    }
    
    var numberCommmentsString: String {
        if self.status.numberComments == 0 {
            return "Add comments..."
        } else {
            if self.status.numberComments == 1 {
                return "See all \(status.numberComments) comment"
            } else {
                return "See all \(status.numberComments) comments"
            }
        }
    }
    
    func hasLikedStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        StatusService.shared.hasUserLikedTus(status: self.status,
                                             uid: uid) { hasLiked in
            self.status.likedStatus = hasLiked
            self.completionLike?()
        }
    }
    
    func likeStatus() {
        self.status.likedStatus = true
        self.status.numberLikes += 1

        StatusService.shared.likeStatus(status: status) {
            self.fetchNumberUsersLikedStatusAfterTapLikeButton()
        }
    }
    
    func unlikeStatus() {
        self.status.likedStatus = false
        self.status.numberLikes -= 1
        
        StatusService.shared.unlikeStatus(status: status) {
            self.fetchNumberUsersLikedStatusAfterTapLikeButton()
        }
    }
    
    private func fetchNumberUsersLikedStatusAfterTapLikeButton() {
        StatusService.shared.fetchNumberUsersLikedStatus(status: status) { number in
            self.completionFetchNumberLikes?()
        }
    }
    
    func fetchNumberUsersLikedStatus() {
        StatusService.shared.fetchNumberUsersLikedStatus(status: status) { number in
            self.status.numberLikes = number
            self.completionFetchNumberLikes?()
        }
    }
    
    func fetchNumberUsersCommented() {
        CommentStatusService.shared.fetchNumberUsersCommented(status: status) { number in
            self.status.numberComments = number
            self.completionFetchNumberUserCommented?()
        }
    }
        
    var completionLike: (() -> Void)?
    var completionFetchNumberLikes: (() -> Void)?
    var completionFetchNumberUserCommented: (() -> Void)?
    
    init(status: StatusModel) {
        self.status = status
    }
}

