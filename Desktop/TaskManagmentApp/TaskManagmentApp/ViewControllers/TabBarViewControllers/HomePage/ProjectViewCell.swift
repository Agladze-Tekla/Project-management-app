//
//  ProjectViewCell.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/4/24.
//

import UIKit

final class ProjectViewCell: UICollectionViewCell {
    static let identifier = "ProjectCollectionCell"
    
    //MARK: - Properties
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.font = .boldSystemFont(ofSize: 20)
           label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .white
           return label
       }()
       
    //MARK: - Init
      override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        addSubViews()
        setUpConstraints()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    //MARK: - Set Up UI
    private func setupBackground() {
        contentView.backgroundColor = .systemIndigo
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
                  titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                  titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                  titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                  titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
              ])
       }
    
    //MARK: - Configure
    func configurate(project: ProjectModel) {
        titleLabel.text = project.title
        }
    
    // MARK: - CellLifeCycle
          override func prepareForReuse() {
              super.prepareForReuse()
            titleLabel.text = nil
          }
}
