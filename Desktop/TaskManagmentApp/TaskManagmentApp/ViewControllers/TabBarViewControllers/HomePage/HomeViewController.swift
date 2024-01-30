//
//  HomeViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: - UI Components

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
    }
    
    private func setupBackground() {
        
    }
    
    private func addSubviews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    @objc private func didTapLogout() {
        SignupViewModel.shared.signOut { [weak self] error in
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
