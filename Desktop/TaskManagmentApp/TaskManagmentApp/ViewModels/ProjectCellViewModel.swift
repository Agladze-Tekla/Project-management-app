//
//  ProjectCellViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/11/24.
//

import UIKit
import Firebase

protocol ProjectCellViewModelDelegate: AnyObject {
    func taskCountFetched(totalTasks: Int, completedTasks: Int)
    func taskCountFetchingFailed(error: Error)
}

final class ProjectCellViewModel {
    weak var delegate: ProjectCellViewModelDelegate?
    
    private let db = Firestore.firestore()
    
    func fetchTaskCount(for projectId: String, completion: @escaping (Int, Int) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("users").document(currentUserID).collection("projects").document(projectId).collection("tasks").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.taskCountFetchingFailed(error: error)
                return
            }
            let totalTasks = snapshot?.count ?? 0
            let completedTasks = snapshot?.documents.filter { document in
                let data = document.data()
                return data["isCompleted"] as? Bool == true
            }
            .count ?? 0
            //self.delegate?.taskCountFetched(totalTasks: totalTasks, completedTasks: completedTasks)
            completion(totalTasks, completedTasks)
        }
    }

}
