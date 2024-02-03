//
//  CustomLabel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/2/24.
//

import UIKit

final class CustomLabel: UILabel {
    enum FontSize {
        case big
        case med
        case small
    }

    init(title: String, fontSize: FontSize) {
        super.init(frame: .zero)
        self.text = title
        let textColor: UIColor = .systemIndigo
        self.textColor = textColor
        self.numberOfLines = 2
       
        switch fontSize {
        case .big:
            self.font = .systemFont(ofSize: 22, weight: .bold)
        case .med:
            self.font = .systemFont(ofSize: 18, weight: .semibold)
        case .small:
            self.font = .systemFont(ofSize: 16, weight: .regular)
        default:
            self.font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
