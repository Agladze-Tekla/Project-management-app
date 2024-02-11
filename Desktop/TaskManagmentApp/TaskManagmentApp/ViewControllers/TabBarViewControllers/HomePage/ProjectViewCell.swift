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
           label.textColor = .white
           return label
       }()
    
    private var currentProject: ProjectModel?
    
    private var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.backgroundColor = .purple//UIColor.systemIndigo.withAlphaComponent(0.3)
        bar.progressTintColor = .white
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
       
    private let cellStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
      override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        addSubViews()
        setUpConstraints()
        setupProgressBar()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    //MARK: - Set Up UI
    private func setupBackground() {
        contentView.backgroundColor = .systemIndigo
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    private func addSubViews() {
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(progressBar)
        contentView.addSubview(cellStackView)
        }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor, constant: -20),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
       }
    
    private func setupProgressBar() {
        let completedTasks = 13
        let allTasks = 19
        let progress = Float(completedTasks)/Float(allTasks)
        progressBar.setProgress(progress, animated: true)
    }
    
    //MARK: - Configure
    func configurate(project: ProjectModel) {
        currentProject = project
        titleLabel.text = project.title
        }
    
    // MARK: - CellLifeCycle
          override func prepareForReuse() {
              super.prepareForReuse()
            titleLabel.text = nil
          }
}
