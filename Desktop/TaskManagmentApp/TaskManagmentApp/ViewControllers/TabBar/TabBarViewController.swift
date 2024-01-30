//
//  TabBarViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/20/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabs()
    }
    
    // MARK: - Private Methods
    private func setupTabBar() {
        tabBar.barTintColor = .secondarySystemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemBackground
    }
    
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeViewController())
        let tasks = self.createNav(with: "Tasks", and: UIImage(systemName: "list.bullet"), vc: TaskViewController())
        self.setViewControllers([home, tasks], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
}

