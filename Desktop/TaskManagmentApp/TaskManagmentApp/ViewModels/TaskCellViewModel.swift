//
//  TaskCellViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/10/24.
//

import UIKit
import Firebase

protocol TaskCellViewModelDelegate: AnyObject {
    func fetchTask(_ task: TaskModel)
}

final class TaskCellViewModel: UIViewController {
    weak var delegate: TaskCellViewModelDelegate?

    private let db = Firestore.firestore()
    
    func toggleIsComplete(task: TaskModel, projectId: String) {
        var taskCopy = task
        taskCopy.setDone(!task.isCompleted)
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(currentUserID).collection("projects").document(projectId).collection("tasks").document(taskCopy.id).setData(taskCopy.asDictionary())
        
        self.delegate?.fetchTask(taskCopy)
    }
}
