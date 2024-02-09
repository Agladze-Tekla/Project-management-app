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

            init(id: String, project: String, title: String, description: String?, isCompleted: Bool, date: Date) {
                self.id = id
                self.project = project
                self.title = title
                self.description = description
                self.isCompleted = isCompleted
                self.date = date
            }

            private enum CodingKeys: String, CodingKey {
                case id
                case project
                case title
                case description
                case isCompleted
                case date
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
                title = try container.decode(String.self, forKey: .title)
                description = try container.decode(String?.self, forKey: .description)
                id = try container.decode(String.self, forKey: .id)
                project = try container.decode(String.self, forKey: .project)

                let timestamp = try container.decode(Double.self, forKey: .date)
                date = Date(timeIntervalSince1970: timestamp)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(isCompleted, forKey: .isCompleted)
                try container.encode(title, forKey: .title)
                try container.encode(description, forKey: .description)
                try container.encode(id, forKey: .id)
                try container.encode(project, forKey: .project)

                try container.encode(date.timeIntervalSince1970, forKey: .date)
            }
        
    }
