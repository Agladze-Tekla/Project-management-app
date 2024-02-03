//
//  ProjectViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import Foundation
import Firebase

enum addingError: Error {
   case emptyTitle
   case addingFailed(Error)
}

protocol ProjectViewModelDelegate: AnyObject {
   func projectAddedSuccessfully()
   func projectAddingFailed(_ error: addingError)
}

class ProjectViewModel {
   weak var delegate: ProjectViewModelDelegate?

   private let db = Firestore.firestore()

   func addProject(title: String, description: String?) {
    guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
           delegate?.projectAddingFailed(.emptyTitle)
           return
       }
    guard let uId = Auth.auth().currentUser?.uid else {
        return
    }
    let newId = UUID().uuidString
       let newProject = ProjectModel(
        id: newId,
        title: title,
        description: description,
        tasks: nil)
       db.collection("users")
        .document(uId)
        .collection("projects")
        .document(newId)
        .setData(newProject.asDictionary()) { [weak self] error in
           guard let self = self else { return }
           if let error = error {
               self.delegate?.projectAddingFailed(.addingFailed(error))
               return
           }
   }
           self.delegate?.projectAddedSuccessfully()

   }
}
