//
//  HomeViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

protocol HomeViewModelDelegate: AnyObject {
    func didLogoutSuccessfully()
    func didFailLogout(error: Error)
    func projectsFetched(_ projects: [ProjectModel])
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private let db = Firestore.firestore()
    
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
    
    deinit {
        print("HomeViewModel deinitialized")
    }
    
    private var projects = [ProjectModel]()

        func fetchProjects() {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                return
            }

            db.collection("users").document(currentUserID).collection("projects").getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching projects: \(error.localizedDescription)")
                    return
                }

                var fetchedProjects = [ProjectModel]()

                for document in snapshot?.documents ?? [] {
                    do {
                        if let projectData = try document.data(as: ProjectModel.self) {
                                                fetchedProjects.append(projectData)
                                            } else {
                                                print("Error: Project data is nil.")
                                            }
                    } catch {
                        print("Error decoding project data: \(error.localizedDescription)")
                    }
                }

                self.projects = fetchedProjects
                self.delegate?.projectsFetched(fetchedProjects)
            }
        }
    
    
    
}
