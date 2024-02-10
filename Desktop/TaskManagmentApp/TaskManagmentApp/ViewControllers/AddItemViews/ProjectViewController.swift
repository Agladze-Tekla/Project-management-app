//
//  ProjectViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit

final class ProjectViewController: UIViewController {
    //MARK: - UI Components
    private let viewModel = ProjectViewModel();
    
    private let saveProjectButton = CustomButton(title: "Save Project", hasBackground: true, fontSize: .med)
    
    private let titleTextField = CustomTextField(fieldType: .title)
    
    private let titleLabel = CustomLabel(title: "Project Title", fontSize: .med)
    
    private let descriptionTextField1 = CustomTextField(fieldType: .description)
    
    private let descriptionLabel = CustomLabel(title: "Project Description", fontSize: .med)

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
    
    private let projectStackView: UIStackView = {
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
    
    private let projectInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupButtons()
    }
    
    private func setupBackground() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        projectInfoStackView.addArrangedSubview(titleLabel)
        projectInfoStackView.addArrangedSubview(titleTextField)
        projectInfoStackView.addArrangedSubview(descriptionLabel)
        projectInfoStackView.addArrangedSubview(descriptionTextField)
        projectStackView.addArrangedSubview(projectInfoStackView)
        projectStackView.addArrangedSubview(saveProjectButton)
        view.addSubview(projectStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            projectStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 55),
            titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            saveProjectButton.heightAnchor.constraint(equalToConstant: 55),
            saveProjectButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 250),
            descriptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        saveProjectButton.addTarget(self, action: #selector(didTapAddProject), for: .touchUpInside)
    }
    
    @objc private func didTapAddProject() {
          viewModel.addProject(title: titleTextField.text ?? "", description:descriptionTextField.text)
      }
}

//MARK: - Extensions
extension ProjectViewController: ProjectViewModelDelegate {
    func projectAddedSuccessfully() {
        let vc = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func projectAddingFailed(_ error: addingError) {
        switch error {
        case .addingFailed(let error):
            AlertManager.showAddProjectError(on: self, error: error)
        case .emptyTitle:
            AlertManager.showNoProjectTitleAlert(on: self)
        }
    }
}
