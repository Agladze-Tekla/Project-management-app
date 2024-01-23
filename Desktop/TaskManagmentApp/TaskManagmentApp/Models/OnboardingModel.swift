//
//  OnboardingModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/23/24.
//

import Foundation
import SwiftUI

struct PageModel: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var image: Image
    var description: [String]
    var tag: Int
    
    static var samplePage = PageModel(name: "Title", image: Image(systemName: "sun.max.circle.fill"), description: ["Hiiiiiiii", "whatup"], tag: 0)
    
}
