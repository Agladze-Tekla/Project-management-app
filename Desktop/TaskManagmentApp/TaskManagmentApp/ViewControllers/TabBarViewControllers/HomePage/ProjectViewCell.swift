//
//  ProjectViewCell.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/4/24.
//

import UIKit

final class ProjectViewCell: UICollectionViewCell {
    //MARK: - Properties
    private var viewModel = ProjectCellViewModel()
    
    static let identifier = "ProjectCollectionCell"
    
    private var completedTasks: Int?
    
    private var totalTasks: Int?
    
    //MARK: - UI Components
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.font = .boldSystemFont(ofSize: 20)
           label.numberOfLines = 6
        label.lineBreakMode = .byWordWrapping
           label.textColor = .white
           return label
       }()
    
    private var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.backgroundColor = .purple
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
        viewModel.delegate = self
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
    
    private func setupProgressBar(totalTasks: Int, completedTasks: Int) {
        let progress = Float(completedTasks )/Float(totalTasks)
        progressBar.setProgress(progress, animated: true)
    }
    
    //MARK: - Configure
    func configurate(project: ProjectModel) {
        viewModel.fetchTaskCount(for: project.id) { totalTasks, completedTasks in
            self.setupProgressBar(totalTasks: totalTasks, completedTasks: completedTasks)
        }
        titleLabel.text = project.title
        }
    
    // MARK: - CellLifeCycle
          override func prepareForReuse() {
              super.prepareForReuse()
            titleLabel.text = nil
            progressBar.progress = 0
          }
}

//MARK: - Extension
extension ProjectViewCell: ProjectCellViewModelDelegate {
    func taskCountFetched(totalTasks: Int, completedTasks: Int) {
        self.completedTasks = completedTasks
        self.totalTasks = totalTasks
    }
    
    func taskCountFetchingFailed(error: Error) {
        AlertManager.showTasksFetchingError(on: TabBarViewController(), error: error)
    }
}
