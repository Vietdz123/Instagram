//
//  HeaderViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class HeaderProfileViewModel {
    var user: UserModel
    
    var attributedFollowers: NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(user.stats.followers)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: "Followers",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.label]))
        return attributedText
    }
    
    var attributedFollowings: NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(user.stats.followings)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: "Followings",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.label]))
        return attributedText
    }
    
    var attributedPosts: NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(user.numberStatus)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: "Post",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.label]))
        return attributedText
    }
    
    func updateAttributedFollowers(numberFollowers: Int) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(numberFollowers)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: "Followers",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.label]))
        return attributedText
    }
    
    func updateAttributedFollowings(numberFollowing: Int) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(numberFollowing)\n",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                    .foregroundColor: UIColor.label]))
        attributedText.append(NSAttributedString(string: "Followings",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.label]))
        return attributedText
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    var imageAvatarUrl: URL? {
        return URL(string: user.profileImage ?? "")
    }
    
    var bio: String {
        return user.bio ?? ""
    }
    
    var isFollowed: Bool {
        return user.isFollowed
    }
    
    var isCurrentUser: Bool {
        return user.uid == Auth.auth().currentUser?.uid
    }
    
    func followUser() {
        UserService.shared.followUser(uid: user.uid) {
            self.user.isFollowed = true
            self.fetchRelationStats()
        }
    }
    
    func unfollowUser() {
        UserService.shared.unfollowUser(uid: user.uid) {
            self.user.isFollowed = false
            self.fetchRelationStats()
        }
    }
    
    func fetchRelationStats() {
        let uid = self.user.uid
        
        UserService.shared.fetchUserRelationStats(uid: uid) { relationStats in
            self.user.stats = relationStats
            self.completionFetchRelations?()
        }
    }
    
    var completionFetchRelations: (() -> Void)?
    
    init(user: UserModel) {
        self.user = user
    }
}
