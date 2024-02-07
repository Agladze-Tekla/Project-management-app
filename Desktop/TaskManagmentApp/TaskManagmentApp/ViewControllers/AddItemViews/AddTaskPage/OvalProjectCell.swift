//
//  OvalProjectCell.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/6/24.
//

import UIKit

final class OvalProjectCell: UICollectionViewCell {
    static let reuseIdentifier = "OvalCollectionViewCell"

       private let label: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.textColor = .white
           return label
       }()

       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       private func setupUI() {
        contentView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.7)
           contentView.layer.cornerRadius = contentView.frame.height / 2

           contentView.addSubview(label)
           label.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
               label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
               label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
           ])
       }

    func configure(project: ProjectModel, color: UIColor) {
        label.text = project.title
        contentView.backgroundColor = color
       }
}
