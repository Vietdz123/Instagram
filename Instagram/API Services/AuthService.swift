//
//  AuthService.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AuthCrentials {
    var email: String
    var password: String
    var fullName: String
    var userName: String
//    var imageProfile: UIImage
}

class AuthService {
    static let shared = AuthService()
    private let db = Firestore.firestore()
    
    func registerUser(authCretical: AuthCrentials, completion: @escaping(Error?) -> Void) {
        let email = authCretical.email
        let password = authCretical.password
        let fullname = authCretical.fullName
        let username = authCretical.userName
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            let data = ["email": email,
                        "fullname": fullname,
                        "username": username,
                        "uid": uid]
            self.db.collection("users").document(uid).setData(data, completion: completion)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func logOut() {
        do {
          try Auth.auth().signOut()
        } catch {
            print("DEBUG: Cannot LogOut")
        }
        
    }
}
