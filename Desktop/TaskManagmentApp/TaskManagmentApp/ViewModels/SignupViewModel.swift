//
//  SignupViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/24/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

final class SignupViewModel {
    public static let shared = SignupViewModel()
    private init() {}
    
    public func registerUser(userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }
    }
    
    public func signIn(userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { (result, error) in
            if let error = error {
                completion(error)
                return
            } else {
            completion(nil)
        }
    }
    }
    public func signOut(complition: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            complition(nil)
        } catch let error {
            complition(error)
        }
    }
    
}
