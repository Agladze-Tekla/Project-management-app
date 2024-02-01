//
//  HomeViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: - UI Components
    private let projectLabel: UILabel = {
        let label = UILabel()
        label.text = "Projects"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
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
        return stack    }()
    
    private let accountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let todaysTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "You have 9 tasks left for today."
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        //stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let image: UIImageView = {
        var image = UIImage()
        image = UIImage(systemName: "sun.min")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return imageView
    }()

    private let viewModel = LoginViewModel();
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupNavigationButton()
        setupWelcomeLabel()
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
        projectStackView.addArrangedSubview(projectLabel)
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
            projectStackView.topAnchor.constraint(equalTo: accountStackView.bottomAnchor),
           // projectStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            projectStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
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
    
    @objc private func didTapLogout() {
        Authentication.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogOutError(on: self, error: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
            SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
