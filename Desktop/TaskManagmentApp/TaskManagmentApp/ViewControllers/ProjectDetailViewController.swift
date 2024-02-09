//
//  ProjectDetailViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/8/24.
//

import UIKit

final class ProjectDetailViewController: UIViewController {
    // MARK: - Private Properties
      private let project: ProjectModel
    
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return stackView
    }()

    private let projectDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.backgroundColor = .systemIndigo
        stackView.layer.cornerRadius = 13
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    private let taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let labelAndButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private let tasksLabel = CustomLabel(title: "Tasks", fontSize: .med)

private let addTaskButton = CustomButton(title: "+ Add Task", hasBackground: false, fontSize: .small)

    // MARK: - View Lifecycle
    init(project: ProjectModel) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        configure(with: project)
        setupButtons()
    }

    private func setupBackground() {
        view.backgroundColor = .white
    }

    private func addSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(projectDetailStackView)
        mainStackView.addArrangedSubview(taskStackView)
        projectDetailStackView.addArrangedSubview(titleLabel)
        projectDetailStackView.addArrangedSubview(descriptionLabel)
        labelAndButtonStackView.addArrangedSubview(tasksLabel)
        labelAndButtonStackView.addArrangedSubview(addTaskButton)
        taskStackView.addArrangedSubview(labelAndButtonStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func configure(with project: ProjectModel) {
        titleLabel.text = project.title
        descriptionLabel.text = project.description
    }
    
    private func setupButtons() {
        addTaskButton.addTarget(self, action: #selector(didTapNewTask), for: .touchUpInside)
    }
    
    @objc private func didTapNewTask() {
        let vc = TaskDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
