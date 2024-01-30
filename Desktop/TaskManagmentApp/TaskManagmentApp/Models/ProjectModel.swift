//
//  ProjectModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/23/24.
//

import Foundation
import UIKit

struct ProjectModel: Identifiable {
    let id = UUID()
    var title: String
    var description: String?
    var label: UIColor
    var tasks: [TaskModel]?
    
    struct TaskModel: Identifiable {
        let id = UUID()
        var title: String
        var description: String?
        var isCompleted: Bool
        var date: Date
        var startTime: Date
        var endTime: Date
    }
    
    static var sampleProject = ProjectModel(title: "Sample Project", description: "Helps make view and functions", label: .magenta, tasks: [sampleTask])
    static var sampleTask = TaskModel(title: "Sample Task", description: "Helper just like sampleProject", isCompleted: false, date: Date(), startTime: Date(), endTime: Date())
}
