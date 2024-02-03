//
//  HomeViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: - UI Components
    private let addProjectButton = CustomButton(title: "+ Add Project", hasBackground: false, fontSize: .small)
    
    private let addTaskButton = CustomButton(title: "+ Add Task", hasBackground: false, fontSize: .small)
    
    private let projectLabelButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 13
        stack.spacing = 30
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let projectLabel = CustomLabel(title: "Projects", fontSize: .med)
    
    private let projectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.backgroundColor = .systemBackground
        stack.layer.cornerRadius = 25
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let accountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let todaysTaskLabel = CustomLabel(title: "Loading today's tasks...", fontSize: .small)
    
    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let welcomeStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.backgroundColor = .systemBackground
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stack
    }()
    
    private var welcomeLabel = CustomLabel(title: "Loading...", fontSize: .big)
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()

    private let viewModel = HomeViewModel();
    
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
        setupNavigationButton()
        setupWelcomeLabel()
        setupButtons()
    }
    
    private func setupBackground() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        welcomeStackView.addArrangedSubview(image)
        welcomeStackView.addArrangedSubview(welcomeLabel)
        progressStackView.addArrangedSubview(todaysTaskLabel)
        accountStackView.addArrangedSubview(welcomeStackView)
        accountStackView.addArrangedSubview(progressStackView)
        projectLabelButtonStackView.addArrangedSubview(projectLabel)
        projectLabelButtonStackView.addArrangedSubview(addProjectButton)
        projectLabelButtonStackView.addArrangedSubview(addTaskButton)
        projectStackView.addArrangedSubview(projectLabelButtonStackView)
        
        view.addSubview(accountStackView)
        view.addSubview(projectStackView)
    }
    
    private func setupConstraints() {
        setupAccountStackViewConstraints()
        setProjectStackViewConstraints()
    }
    
    private func setupAccountStackViewConstraints() {
        NSLayoutConstraint.activate([
            accountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setProjectStackViewConstraints() {
        NSLayoutConstraint.activate([
            //projectStackView.topAnchor.constraint(equalTo: accountStackView.bottomAnchor),
            projectStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            projectStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    private func setupWelcomeLabel() {
        Authentication.shared.fetchUser { [weak self] user, error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showFetchingUserError(on: self, error: error)
                return
            }
            if let user = user {
                self.welcomeLabel.text = "Welcome\n\(user.username)!"
            }
        }
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        addProjectButton.addTarget(self, action: #selector(didTapNewProject), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(didTapNewTask), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    @objc private func didTapNewProject() {
        let vc = ProjectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapNewTask() {
        let vc = TaskDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogout() {
        viewModel.logout()
    }
}

//MARK: - Extensions
extension HomeViewController: HomeViewModelDelegate {
    func didLogoutSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }

    func didFailLogout(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            AlertManager.showLogOutError(on: self, error: error)
            return
        }
    }
}
