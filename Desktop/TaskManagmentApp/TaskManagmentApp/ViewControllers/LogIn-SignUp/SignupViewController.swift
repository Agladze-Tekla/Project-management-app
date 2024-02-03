//
//  SignupViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class SignupViewController: UIViewController {
        //MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign Up", subTitle: "Create an account")
    
    private let usernameField = CustomTextField(fieldType: .username)
       
    private let emailField = CustomTextField(fieldType: .email)
    
    private let passwordField = CustomTextField(fieldType: .password)

    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    
    private let haveAnAccountButton = CustomButton(title: "Already have an account? Sign in.", hasBackground: false, fontSize: .small)
    
    private let viewModel = SignupViewModel();

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
            view.addSubview(usernameField)
            view.addSubview(emailField)
            view.addSubview(passwordField)
            view.addSubview(signUpButton)
            view.addSubview(haveAnAccountButton)
        }
        
        private func setupConstraints() {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            usernameField.translatesAutoresizingMaskIntoConstraints = false
            haveAnAccountButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 222),
                
                usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
                usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                usernameField.heightAnchor.constraint(equalToConstant: 55),
                usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
                emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                emailField.heightAnchor.constraint(equalToConstant: 55),
                emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
                passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                passwordField.heightAnchor.constraint(equalToConstant: 55),
                passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                signUpButton.heightAnchor.constraint(equalToConstant: 55),
                signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                haveAnAccountButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 11),
                haveAnAccountButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                haveAnAccountButton.heightAnchor.constraint(equalToConstant: 44),
                haveAnAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            ])
        }
        
        private func setupButtons() {
            signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
            haveAnAccountButton.addTarget(self, action: #selector(didTapHaveAnAccount), for: .touchUpInside)
        }
    
    private func setupDelegate() {
    viewModel.delegate = self
    }
    
    @objc private func didTapHaveAnAccount() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        @objc private func didTapSignUp() {
            viewModel.signupUser(
                        username: usernameField.text ?? "",
                        email: emailField.text ?? "",
                        password: passwordField.text ?? ""
                    )
        }
}

//MARK: - Extension
extension SignupViewController: SignupViewModelDelegate {
    func signupSuccess() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }

    func signupError(_ error: SignupError) {
        switch error {
        case .invalidUsername:
            AlertManager.showInvaliUsernameAlert(on: self)
        case .invalidEmail:
            AlertManager.showInvaliEmailAlert(on: self)
        case .invalidPassword:
            AlertManager.showInvaliPasswordAlert(on: self)
        case .registrationError(let registrationError):
            AlertManager.showRegistrationAlert(on: self, error: registrationError)
        case .unknownError:
            AlertManager.showRegistrationAlert(on: self)
        }
    }
}
