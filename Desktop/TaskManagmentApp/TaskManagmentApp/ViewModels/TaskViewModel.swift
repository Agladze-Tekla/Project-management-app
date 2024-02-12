//
//  TaskViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/11/24.
//

import UIKit
import Firebase

protocol TaskViewModelDelegate: AnyObject {
    func tasksFetched(_ tasks: [TaskModel])
    func tasksFetchingFailed(_ error: Error)
    func taskDeleteFailed(_ error: Error)
}

final class TaskViewModel {
    
    weak var delegate: TaskViewModelDelegate?

    private let db = Firestore.firestore()
    
    func getProjectName(projectID: String, completion: @escaping (String?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let projectRef = db.collection("users").document(currentUserID).collection("projects").document(projectID)

        projectRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching project: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = document, document.exists {
                do {
                    if let projectData = try document.data(as: ProjectModel.self) {
                        completion(projectData.title)
                    } else {
                        print("Error: Project data is nil.")
                        completion(nil)
                    }
                } catch {
                    print("Error decoding project data: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("Project document does not exist for ID: \(projectID)")
                completion(nil)
            }
        }
    }
    
    
     func fetchProjectIDs(completion: @escaping ([String]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }

        var fetchedProjectsId = [String]()

        db.collection("users").document(currentUserID).collection("projects").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching projects: \(error.localizedDescription)")
                completion([])
                return
            }

            for document in snapshot?.documents ?? [] {
                do {
                    if let projectData = try document.data(as: ProjectModel.self) {
                        fetchedProjectsId.append(projectData.id)
                    } else {
                        print("Error: Project data is nil.")
                    }
                } catch {
                    print("Error decoding project data: \(error.localizedDescription)")
                }
            }

            completion(fetchedProjectsId)
        }
    }
    
    
    func fetchTasks(calendarDate: Date) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        fetchProjectIDs { fetchedProjectsId in
            var allTasks = [TaskModel]()

            let dispatchGroup = DispatchGroup()

            for project in fetchedProjectsId {
                dispatchGroup.enter()

                self.db.collection("users").document(currentUserID).collection("projects").document(project).collection("tasks").getDocuments { snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }

                    if let error = error {
                        print("Error fetching tasks: \(error.localizedDescription)")
                        return
                    }

                    for document in snapshot?.documents ?? [] {
                        do {
                            if let taskData = try document.data(as: TaskModel.self) {
                                allTasks.append(taskData)
                            } else {
                                print("Error: Task data is nil.")
                            }
                        } catch {
                            print("Error decoding task data: \(error.localizedDescription)")
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                let todaysTasks = allTasks.filter { task in
                    let calendar = Calendar.current
                    return calendar.isDate(task.date, inSameDayAs: calendarDate)
                }

                let incompleteTasks = todaysTasks.filter { task in
                    return !task.isCompleted
                }
                self.delegate?.tasksFetched(todaysTasks)
            }
        }
    }
    
    
    
       func deleteTask(task: TaskModel) {
           guard let currentUserID = Auth.auth().currentUser?.uid else {
               return
           }
           db.collection("users").document(currentUserID).collection("projects").document(task.project).collection("tasks").document(task.id).delete() { error in
               if let error = error {
                   self.delegate?.taskDeleteFailed(error)
               }
           }
       }
    
    
}
