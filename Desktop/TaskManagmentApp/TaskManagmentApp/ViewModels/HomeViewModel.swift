//
//  HomeViewModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func didLogoutSuccessfully()
    func didFailLogout(error: Error)
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

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
