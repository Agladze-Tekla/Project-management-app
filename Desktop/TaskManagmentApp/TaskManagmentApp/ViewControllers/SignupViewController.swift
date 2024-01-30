//
//  SignupViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

class SignupViewController: UIViewController {
        //MARK: - UI Components
        private let headerView = AuthHeaderView(title: "Sign Up", subTitle: "Create an account")
    private let usernameField = CustomTextField(fieldType: .username)
        private let emailField = CustomTextField(fieldType: .email)
        private let passwordField = CustomTextField(fieldType: .password)
        private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)

        //MARK: - ViewLifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
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
            view.addSubview(usernameField)
            view.addSubview(emailField)
            view.addSubview(passwordField)
            view.addSubview(signUpButton)
        }
        
        private func setupConstraints() {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            usernameField.translatesAutoresizingMaskIntoConstraints = false
            
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
                
                signUpButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
                signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                signUpButton.heightAnchor.constraint(equalToConstant: 55),
                signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                usernameField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                usernameField.heightAnchor.constraint(equalToConstant: 55),
                usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            ])
        }
        
        private func setupButtons() {
            signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        }
        
        @objc private func didTapSignUp() {
            let registerUserRequest = RegisterUserRequest(
                username: self.usernameField.text ?? "",
                email: self.emailField.text ?? "",
                password: self.passwordField.text ?? ""
            )
            
            if !Validator.isValidUsername(username: registerUserRequest.username) {
                AlertManager.showInvaliUsernameAlert(on: self)
                return
            }
            
            if !Validator.isValidEmail(email: registerUserRequest.email) {
                AlertManager.showInvaliEmaildAlert(on: self)
                return
            }
            
            if !Validator.isPasswordValid(password: registerUserRequest.password) {
                AlertManager.showInvaliPasswordAlert(on: self)
                return
            }
            SignupViewModel.shared.registerUser(userRequest: registerUserRequest) { [weak self ]
                wasRegistered, error in
                guard let self = self else { return }
                
                if let error = error {
                    AlertManager.showRegistrationAlert(on: self, error: error)
                }
                
                if wasRegistered {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.checkAuthentication()
                    } else {
                        AlertManager.showRegistrationAlert(on: self)
                    }
                }
                
            }
        }

}
