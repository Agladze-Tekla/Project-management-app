//
//  TaskViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class TaskViewController: UIViewController {
    // MARK: - Private Properties
        private var tasks = [TaskModel]()
        
        private var viewModel = TaskViewModel()
        
        // MARK: - UI Components
       private let mainStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
           return stackView
       }()
       
       private let currentDateLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
           label.textColor = .systemIndigo
           return label
       }()
       
       private let calendarStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.layer.cornerRadius = 20
        stackView.backgroundColor = .secondarySystemBackground
           return stackView
       }()
       
       private let taskStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
           return stackView
       }()
       
       private let labelButtonStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .horizontal
           stackView.spacing = 20
           return stackView
       }()
    
    private let tasksTableView: UITableView = {
           let tableView = UITableView()
           tableView.separatorStyle = .none
           tableView.showsVerticalScrollIndicator = false
           return tableView
       }()
    
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 60, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let taskLabel = CustomLabel(title: "Tasks", fontSize: .big)
    
    private let addTaskButton = CustomButton(title: "+ Add Task", hasBackground: false, fontSize: .small)
    
       // MARK: - View Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
        viewModel.delegate = self
        setupTaskView()
       }

       // MARK: - Private Methods
    private func setupTaskView() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 2
        dateComponents.day = 19
        if let specificDate = calendar.date(from: dateComponents) {
            viewModel.fetchTasks(calendarDate: specificDate)
        }
    }
    
       private func setupUI() {
        setupBackground()
               addSubviews()
               setupConstraints()
               setupButtons()
               configureTasksTableView()
        setupCalendarCollectionView()
       }
    
    private func setupBackground() {
        view.backgroundColor = .white
        }

        private func addSubviews() {
            view.addSubview(mainStackView)
            mainStackView.addArrangedSubview(calendarStackView)
            mainStackView.addArrangedSubview(taskStackView)
            calendarStackView.addArrangedSubview(currentDateLabel)
            calendarStackView.addArrangedSubview(calendarCollectionView)
            taskStackView.addArrangedSubview(labelButtonStackView)
            labelButtonStackView.addArrangedSubview(taskLabel)
            labelButtonStackView.addArrangedSubview(addTaskButton)
            taskStackView.addArrangedSubview(tasksTableView)
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                calendarCollectionView.heightAnchor.constraint(equalToConstant: 90)
            ])
        }

    private func setupButtons() {
            addTaskButton.addTarget(self, action: #selector(didTapNewTask), for: .touchUpInside)
        }
        
        private func configureTasksTableView() {
            tasksTableView.delegate = self
            tasksTableView.dataSource = self
            tasksTableView.register(TaskViewCell.self, forCellReuseIdentifier: TaskViewCell.identifier)
            tasksTableView.reloadData()
        }
        
        @objc private func didTapNewTask() {
            let vc = AddTaskViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    private func setupCalendarCollectionView() {
            calendarCollectionView.delegate = self
            calendarCollectionView.dataSource = self
            calendarCollectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: CalendarViewCell.identifier)
        }
   }

// MARK: - UICollectionViewDataSource
extension TaskViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewCell.identifier, for: indexPath) as? CalendarViewCell else {
            fatalError("Unable to dequeue CalendarCell")
        }
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    
}


//MARK: - TableView Extensions
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskViewCell.identifier, for: indexPath) as? TaskViewCell else {
            fatalError("Unable to dequeue TaskCell")
        }
        let task = tasks[indexPath.row]
        cell.configure(task: task, projectId: task.project)
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
        viewModel.getProjectName(projectID: tasks[indexPath.row].project) { projectName in
            if let projectName = projectName {
                let vc = TaskDetailViewController()
                vc.configure(task: self.tasks[indexPath.row], projectTitle: projectName)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Transition Extension
extension TaskViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TaskPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - TaskViewModelDelegate
extension TaskViewController: TaskViewModelDelegate {
    func tasksFetched(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tasksTableView.reloadData()
    }
    
    func tasksFetchingFailed(_ error: Error) {
        AlertManager.showTasksFetchingError(on: self, error: error)
    }
    
    func taskDeleteFailed(_ error: Error) {
        AlertManager.showTasksDeleteError(on: self, error: error)
    }
}
