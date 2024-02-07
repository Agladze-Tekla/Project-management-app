//
//  TaskDetailViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/2/24.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    //MARK: - UI Components
    private let viewModel = TaskViewModel();
    
    private let saveTaskButton = CustomButton(title: "Save Task", hasBackground: true, fontSize: .med)
    
    private let titleTextField = CustomTextField(fieldType: .title)
    
    private let titleLabel = CustomLabel(title: "Task Title", fontSize: .med)
    
    private let descriptionLabel = CustomLabel(title: "Task Description", fontSize: .med)

    private let descriptionTextField: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemIndigo
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.returnKeyType = .done
        view.autocorrectionType = .no
        return view
    }()
    
    private let taskStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 40
        stack.distribution = .equalSpacing
        stack.backgroundColor = .systemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let taskInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let dueDateLabel = CustomLabel(title: "Due Date", fontSize: .med)
    
    //TODO: FIX DUE DATE IMPLEMENTATION
    private let dueDateTextField: UITextField = {
        let textField = UITextField()
                textField.placeholder = "Select Date"
                textField.textAlignment = .center
                textField.backgroundColor = .secondarySystemBackground
                textField.inputView = UIDatePicker()
                return textField
      }()
    
    private let projectLabel = CustomLabel(title: "To Project:", fontSize: .med)
    
    private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()

    private var projects = [ProjectModel]()
    
    private var projectId = ""
    
    private var selectedDate: Date?

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProjects()
        setupCollectionview()
        setupDelegates()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupButtons()
        setupDatePicker()
    }
    
    private func setupBackground() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        taskInfoStackView.addArrangedSubview(titleLabel)
        taskInfoStackView.addArrangedSubview(titleTextField)
        taskInfoStackView.addArrangedSubview(descriptionLabel)
        taskInfoStackView.addArrangedSubview(descriptionTextField)
        taskInfoStackView.addArrangedSubview(dueDateLabel)
        taskInfoStackView.addArrangedSubview(dueDateTextField)
        taskInfoStackView.addArrangedSubview(projectLabel)
        taskInfoStackView.addArrangedSubview(collectionView)
        taskStackView.addArrangedSubview(taskInfoStackView)
        taskStackView.addArrangedSubview(saveTaskButton)
        view.addSubview(taskStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 55),
            titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 55),
            saveTaskButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 150),
            descriptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            collectionView.widthAnchor.constraint(equalTo: taskInfoStackView.widthAnchor),
                  collectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        saveTaskButton.addTarget(self, action: #selector(didTapAddTask), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        if let datePicker = dueDateTextField.inputView as? UIDatePicker {
                   datePicker.datePickerMode = .date
                   datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
                   datePicker.date = Date()
               }
    }

    private func setupTapGestureRecognizer() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
         view.addGestureRecognizer(tapGesture)
     }

     @objc private func handleTap() {
         dueDateTextField.resignFirstResponder()
     }

     @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
         selectedDate = sender.date
         let dateFormatter = DateFormatter()
         dateFormatter.dateStyle = .medium
         dueDateTextField.text = dateFormatter.string(from: sender.date)
     }
    
    private func setupCollectionview() {
        collectionView.dataSource = self
               collectionView.delegate = self
        collectionView.register(OvalProjectCell.self, forCellWithReuseIdentifier: OvalProjectCell.reuseIdentifier)
    }
    
    private func setupProjects() {
        viewModel.fetchProjects()
    }

    @objc private func dismissDatePicker() {
        view.endEditing(true)
    }
    
    @objc private func didTapAddTask() {
        viewModel.addTask(title: titleTextField.text ?? "", description: descriptionTextField.text, isCompleted: false, date: selectedDate?.timeIntervalSince1970 ?? 0, projectID: projectId)
      }
}

//MARK: - Extensions
extension TaskDetailViewController: TaskViewModelDelegate {
    func projectsFetched(_ projects: [ProjectModel]) {
        self.projects = projects
        collectionView.reloadData()
    }
    
    func taskAddedSuccessfully() {
            let vc = TabBarViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
    }
    
    func taskAddingFailed(_ error: savingError) {
        switch error {
        case .addingFailed(let error):
            AlertManager.showAddTasktError(on: self, error: error)
        case .emptyTitle:
            AlertManager.showNoTaskTitleAlert(on: self)
        case .emptyDate:
            AlertManager.showNoTaskDateAlert(on: self)
        case .emptyID:
            AlertManager.noChosenProjectAler(on: self)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TaskDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OvalProjectCell.reuseIdentifier, for: indexPath) as? OvalProjectCell else {
            return UICollectionViewCell()
        }
        var projectColor = UIColor.systemIndigo.withAlphaComponent(0.7)
        if projects[indexPath.row].id == projectId {
                    projectColor = .systemIndigo
                }
        cell.configure(project: projects[indexPath.row], color: projectColor)
        
        return cell
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProject = projects[indexPath.item].id
               projectId = selectedProject
               collectionView.reloadData()
      }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = projects[indexPath.item].title
        let width = text.width(withConstrainedHeight: collectionView.frame.height, font: UIFont.systemFont(ofSize: 17))
        return CGSize(width: width + 32, height: collectionView.frame.height)
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}
