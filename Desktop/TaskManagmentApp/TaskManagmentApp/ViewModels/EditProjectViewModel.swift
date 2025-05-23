//
//  EditProjectViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/10/24.
//

import UIKit
import Firebase

protocol EditProjectViewModelDelegate: AnyObject {
    func editProject(_ project: ProjectModel)
    func projectAddingFailed(_ error: addingError)
    func projectDeleteFailed(_ error: Error)
    func projectDeletedSuccesfully()
}

final class EditProjectViewModel {
    weak var delegate: EditProjectViewModelDelegate?

    private let db = Firestore.firestore()
    
    func saveProject(project: ProjectModel) {
        guard !project.title.trimmingCharacters(in: .whitespaces).isEmpty else {
               delegate?.projectAddingFailed(.emptyTitle)
               return
           }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(currentUserID).collection("projects").document(project.id).setData(project.asDictionary())
        
        self.delegate?.editProject(project)
    }
    
    func deleteProject(for projectId: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(currentUserID).collection("projects").document(projectId).delete() { error in
            if let error = error {
                self.delegate?.projectDeleteFailed(error)
            } else {
                self.delegate?.projectDeletedSuccesfully()
            }
        }
    }
}
