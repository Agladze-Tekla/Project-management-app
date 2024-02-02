//
//  LoginViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/24/24.
//

import Foundation

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
    case authenticationError
}

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginError(_ error: LoginError)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    func loginUser(email: String, password: String) {
        let loginRequest = LoginUserRequest(email: email, password: password)

        if !Validator.isValidEmail(email: loginRequest.email) {
            delegate?.loginError(.invalidEmail)
            return
        }

        if !Validator.isPasswordValid(password: loginRequest.password) {
            delegate?.loginError(.invalidPassword)
            return
        }

        Authentication.shared.signIn(userRequest: loginRequest) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.delegate?.loginError(.authenticationError)
                return
            }

            self.delegate?.loginSuccess()
        }
    }
}
