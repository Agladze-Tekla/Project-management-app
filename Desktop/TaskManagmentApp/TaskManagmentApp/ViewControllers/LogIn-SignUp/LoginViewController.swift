//
//  LoginViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class LoginViewController: UIViewController {
    //MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Log In", subTitle: "Sign in to your account")
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Log In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "Don't have an account? Sign up.", hasBackground: false, fontSize: .small)
    private let viewModel = LoginViewModel()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupButtons()
    }
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(newUserButton)
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 222),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    private func setupButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    @objc private func didTapSignIn() {
        viewModel.loginUser(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func didTapNewUser() {
        let vc = SignupViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extensions
extension LoginViewController: LoginViewModelDelegate {
    func loginSuccess() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                   sceneDelegate.checkAuthentication()
               }
    }
    
    func loginError(_ error: LoginError) {
        switch error {
                case .invalidEmail:
                    AlertManager.showInvaliEmailAlert(on: self)
                case .invalidPassword:
                    AlertManager.showInvaliPasswordAlert(on: self)
                case .authenticationError:
                    AlertManager.showSignInErrorAlert(on: self)
                }
    }
}
