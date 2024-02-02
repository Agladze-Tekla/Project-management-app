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
    
    private let saveProjectButton = CustomButton(title: "Save Project", hasBackground: true, fontSize: .big)
    
    private let titleTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Title"
          textField.borderStyle = .roundedRect
          return textField
      }()

      private let descriptionTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Description"
          textField.borderStyle = .roundedRect
          return textField
      }()
    
    private let projectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.backgroundColor = .systemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
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
    }
    
    private func setupBackground() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        projectStackView.addArrangedSubview(titleTextField)
        projectStackView.addArrangedSubview(descriptionTextField)
        projectStackView.addArrangedSubview(saveProjectButton)
        view.addSubview(projectStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            projectStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            projectStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        saveProjectButton.addTarget(self, action: #selector(didTapAddProject), for: .touchUpInside)
    }
    
    @objc private func didTapAddProject() {
          viewModel.addProject(title: titleTextField.text ?? "", description: descriptionTextField.text)
      }
}

//MARK: - Extensions
extension ProjectViewController: ProjectViewModelDelegate {
    func projectAddedSuccessfully() {
        let vc = HomeViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func projectAddingFailed(_ error: addingError) {
        switch error {
        case .addingFailed(let error):
            AlertManager.showAddProjectError(on: self, error: error)
        case .emptyTitle:
            AlertManager.showNoTitleAlert(on: self)
        }
    }
}
