//
//  ProjectModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/23/24.
//

import Foundation
import UIKit

struct ProjectModel: Codable {
    let id: String
    var title: String
    var description: String?
}
    struct TaskModel: Codable {
        let id: String
        var project: String
        var title: String
        var description: String?
        var isCompleted: Bool
        var date: Date
        
        mutating func setDone(_ state: Bool) {
            isCompleted = state
        }
    }
