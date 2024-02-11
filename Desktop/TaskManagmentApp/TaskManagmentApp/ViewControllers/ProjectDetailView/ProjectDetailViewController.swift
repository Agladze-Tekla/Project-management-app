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
    
    private var tasks = [TaskModel]()
    
    private var viewModel = ProjectDetailViewModel()
    
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
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 7
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

    private let tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let tasksLabel = CustomLabel(title: "Tasks", fontSize: .big)

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
        viewModel.fetchTasks(for: project.id)
        setupUI()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private Methods
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        configure(with: project)
        setupButtons()
        configureTasksTableView()
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Project", style: .plain, target: self, action: #selector(didTapEditProject))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Go Home", style: .plain, target: self, action: #selector(didTapGoHome))
    }
    
    private func configureTasksTableView() {
        taskStackView.addArrangedSubview(tasksTableView)
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        tasksTableView.register(TaskViewCell.self, forCellReuseIdentifier: TaskViewCell.identifier)
        tasksTableView.backgroundColor = .clear
        tasksTableView.reloadData()
    }
    
    @objc private func didTapNewTask() {
        let vc = AddTaskViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapEditProject() {
        let vc = EditProjectViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.configure(project: project)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGoHome() {
        let vc = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - Extensions
extension ProjectDetailViewController: ProjectDetailViewModelDelegate {
    func taskDeleteFailed(_ error: Error) {
        AlertManager.showTasksDeleteError(on: self, error: error)
    }
    
    func tasksFetchedSuccessfully(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tasksTableView.reloadData()
    }
    
    func tasksFetchingFailed(_ error: Error) {
        AlertManager.showTasksFetchingError(on: self, error: error)
    }
}

//MARK: - TableView Extensions
extension ProjectDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskViewCell.identifier, for: indexPath) as? TaskViewCell else {
            fatalError("Unable to dequeue TaskCell")
        }
        let task = tasks[indexPath.row]
        cell.configure(task: task, projectId: project.id)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(task: tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //TODO: NAVIGATE TO DETAILS PAGE
        /*
        let selectedTask = tasks[indexPath.row]
        let vc = EditTaskViewController()
        vc.configure(task: selectedTask)
        vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
 */
        let vc = EditTaskViewController()
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self.present(vc, animated: true, completion: nil)
       }
}

//MARK: - Transition Extension
extension ProjectDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TaskPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
