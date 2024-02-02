//
//  SignupViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import Foundation

enum SignupError: Error {
    case invalidUsername
    case invalidEmail
    case invalidPassword
    case registrationError(Error)
    case unknownError
}

protocol SignupViewModelDelegate: AnyObject {
    func signupSuccess()
    func signupError(_ error: SignupError)
}

final class SignupViewModel {
    weak var delegate: SignupViewModelDelegate?

    func signupUser(username: String, email: String, password: String) {
        let registerUserRequest = RegisterUserRequest(
            username: username,
            email: email,
            password: password
        )

        if !Validator.isValidUsername(username: registerUserRequest.username) {
            delegate?.signupError(.invalidUsername)
            return
        }

        if !Validator.isValidEmail(email: registerUserRequest.email) {
            delegate?.signupError(.invalidEmail)
            return
        }

        if !Validator.isPasswordValid(password: registerUserRequest.password) {
            delegate?.signupError(.invalidPassword)
            return
        }

        Authentication.shared.registerUser(userRequest: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }

            if let error = error {
                self.delegate?.signupError(.registrationError(error))
                return
            }

            if wasRegistered {
                self.delegate?.signupSuccess()
            } else {
                self.delegate?.signupError(.unknownError)
            }
        }
    }
}

