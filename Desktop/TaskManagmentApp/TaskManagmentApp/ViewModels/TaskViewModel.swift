//
//  TaskViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import Foundation
import Firebase

enum savingError: Error {
   case emptyTitle
    case emptyDate
   case addingFailed(Error)
}

protocol TaskViewModelDelegate: AnyObject {
   func taskAddedSuccessfully()
   func taskAddingFailed(_ error: savingError)
}


final class TaskViewModel {
    weak var delegate: TaskViewModelDelegate?

    private let db = Firestore.firestore()

    func addTask(title: String, description: String?, isCompleted: Bool, date: TimeInterval, projectID: String) {
     guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            delegate?.taskAddingFailed(.emptyTitle)
            return
        }
        
     guard let uId = Auth.auth().currentUser?.uid else {
         return
     }
     let newId = UUID().uuidString
        let newTask = TaskModel(id: newId, project: projectID, title: title, description: description, isCompleted: false, date: date)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("projects")
            .document(projectID)
            .collection("tasks")
            .document(newId)
            .setData(newTask.asDictionary()) { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                self.delegate?.taskAddingFailed(.addingFailed(error))
                   return
               }
       }
            self.delegate?.taskAddedSuccessfully()
}
}
