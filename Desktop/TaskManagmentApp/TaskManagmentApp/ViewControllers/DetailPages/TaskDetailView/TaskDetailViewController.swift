//
//  TaskDetailViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/11/24.
//

import UIKit

final class TaskDetailViewController: UIViewController {
//MARK: - Propertis
    private var titleLabel = CustomLabel(title: "Loading...", fontSize: .big)
    
    private var descriptionTitleLabel = CustomLabel(title: "Description", fontSize: .med)
    
    private let dueDateLabel = CustomLabel(title: "Date:", fontSize: .med)
    
    private let projectLabel = CustomLabel(title: "Project", fontSize: .med)
    
    private let taskStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 16
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 13
        stack.clipsToBounds = true
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 0
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let projectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.systemIndigo.withAlphaComponent(0.7)
        return label
    }()
    
    private let project: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.systemIndigo.withAlphaComponent(0.7)
        return label
    }()
    
    private let descriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let dueDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.systemIndigo.withAlphaComponent(0.7)
        return label
    }()
    
//MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
  //MARK: - Configure
    func configure(task: TaskModel, projectTitle: String) {
        titleLabel.text = task.title
        if (task.description ?? "").isEmpty {
            descriptionLabel.text = "No description"
            descriptionLabel.textColor = .lightGray
        } else {
        descriptionLabel.text = task.description
        }
        project.text = projectTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: task.date)
        dueDate.text = dateString
    }
    //MARK: - Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupButtons()
    }

    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(taskStackView)
        dateStackView.addArrangedSubview(dueDateLabel)
        dateStackView.addArrangedSubview(dueDate)
        projectStackView.addArrangedSubview(projectLabel)
        projectStackView.addArrangedSubview(project)
        descriptionStackView.addArrangedSubview(descriptionTitleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        taskStackView.addArrangedSubview(titleLabel)
        taskStackView.addArrangedSubview(dateStackView)
        taskStackView.addArrangedSubview(projectStackView)
        taskStackView.addArrangedSubview(descriptionStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            taskStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            taskStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupButtons() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Task", style: .plain, target: self, action: #selector(didTapEditTask))
    }
    
    @objc private func didTapEditTask() {
        print("Navigating to editTaskViewController...")
    }
}
