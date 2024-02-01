//
//  LoginViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/24/24.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didLogoutSuccessfully()
    func didFailLogout(error: Error)
}

final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    func logout() {
        Authentication.shared.signOut { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.delegate?.didFailLogout(error: error)
                return
            }
            self.delegate?.didLogoutSuccessfully()
        }
    }
}

