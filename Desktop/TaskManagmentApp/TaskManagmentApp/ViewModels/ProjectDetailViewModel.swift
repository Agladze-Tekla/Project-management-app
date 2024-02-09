//
//  ProjectDetailViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/9/24.
//

import UIKit
import Firebase

protocol ProjectDetailViewModelDelegate: AnyObject {
    func tasksFetchedSuccessfully(_ tasks: [TaskModel])
    func tasksFetchingFailed(_ error: Error)
}

final class ProjectDetailViewModel {
    weak var delegate: ProjectDetailViewModelDelegate?

    private let db = Firestore.firestore()

    func fetchTasks(for projectId: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("users").document(currentUserID).collection("projects").document(projectId).collection("tasks").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }

            var fetchedTasks = [TaskModel]()

            for document in snapshot?.documents ?? [] {
                do {
                    if let taskData = try document.data(as: TaskModel.self) {
                        fetchedTasks.append(taskData)
                    } else {
                        print("Error: Task data is nil.")
                    }
                } catch {
                    print("Error decoding task data: \(error.localizedDescription)")
                }
            }

            self.delegate?.tasksFetchedSuccessfully(fetchedTasks)
        }
    }
}

