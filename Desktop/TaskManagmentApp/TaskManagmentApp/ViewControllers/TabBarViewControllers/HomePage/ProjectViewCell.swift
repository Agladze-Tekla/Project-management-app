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
       private let cellStackView: UIStackView = {
           let stack = UIStackView()
           stack.axis = .vertical
           stack.spacing = 3
           stack.translatesAutoresizingMaskIntoConstraints = false
           return stack
       }()
       
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.font = .boldSystemFont(ofSize: 16)
           label.numberOfLines = 2
           label.textColor = .white
           return label
       }()
       
       private let descriptionLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
           label.numberOfLines = 5
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
        cellStackView.backgroundColor = .systemIndigo
    }
    
    private func addSubViews() {
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(cellStackView)
        }
    
    private func setUpConstraints() {
           NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 270),
            contentView.widthAnchor.constraint(equalToConstant: 250)
           ])
       }
    
    //MARK: - Configure
    func configurate(project: ProjectModel) {
        titleLabel.text = project.title
        descriptionLabel.text = project.description
        }
    
    // MARK: - CellLifeCycle
          override func prepareForReuse() {
              super.prepareForReuse()
            titleLabel.text = nil
            descriptionLabel.text = nil
          }
}
