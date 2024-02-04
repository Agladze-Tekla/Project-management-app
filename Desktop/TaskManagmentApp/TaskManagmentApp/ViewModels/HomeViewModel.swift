//
//  HomeViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit
import Firebase

protocol HomeViewModelDelegate: AnyObject {
    func didLogoutSuccessfully()
    func didFailLogout(error: Error) 
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

    func logout() {
        Authentication.shared.signOut { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.delegate?.didFailLogout(error: error)
                return
            }
            self.delegate?.didLogoutSuccessfully()
        }
    }
    
        func checkForProjects(completion: @escaping (Bool, Error?) -> Void) {
            guard let uId = Auth.auth().currentUser?.uid else {
                return
            }
            let db = Firestore.firestore()
               
            db.collection("users")
             .document(uId)
             .collection("projects")
             .getDocuments { (snapshot, error) in
                   if let error = error {
                       completion(false, error)
                       return
                   }
                   let isEmpty = snapshot?.documents.isEmpty ?? true
                   completion(isEmpty, nil)
        }
        }
}
