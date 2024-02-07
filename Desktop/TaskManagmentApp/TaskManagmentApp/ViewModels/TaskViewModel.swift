//
//  TaskViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import Foundation
import Firebase
//TODO: ADD MORE ERROR VARIATIONS: NO-DATE, NO-PROJECT
enum savingError: Error {
   case emptyTitle
    case emptyDate
   case addingFailed(Error)
}

protocol TaskViewModelDelegate: AnyObject {
   func taskAddedSuccessfully()
   func taskAddingFailed(_ error: savingError)
    func projectsFetched(_ projects: [ProjectModel])
}

final class TaskViewModel {
    weak var delegate: TaskViewModelDelegate?

    private let db = Firestore.firestore()

    
    //addTask
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
    
    
    //fetchProjects
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
