//
//  HomeViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

enum FetchingError: Error {
    case projectsFetchingFailed(Error)
    case tasksFetchingFailed(Error)
}

protocol HomeViewModelDelegate: AnyObject {
    func didLogoutSuccessfully()
    func didFailLogout(error: Error)
    func projectsFetched(_ projects: [ProjectModel])
    func taskCountFetchingFailed(error: Error)
    func taskCountFetched(allTasks: Int, incompleteTasks: Int)
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private let db = Firestore.firestore()
    
    
    //logout()
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
    
    
    //checkForProjects
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
    
    
    func fetchTaskCount() {
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
                    let today = calendar.startOfDay(for: Date())
                    return calendar.isDate(task.date, inSameDayAs: today)
                }

                let incompleteTasks = todaysTasks.filter { task in
                    return !task.isCompleted
                }
                self.delegate?.taskCountFetched(allTasks: todaysTasks.count, incompleteTasks: incompleteTasks.count)
            }
        }
    }


    
}
