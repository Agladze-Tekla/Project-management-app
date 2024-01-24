//
//  OnboardingViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/23/24.
//

import UIKit
import SwiftUI

final class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboarding()
    }
    
    private func setupOnboarding() {
        
        let swiftUIView = OnboardingView()
        let hostingController = UIHostingController(rootView: swiftUIView)
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)

    NSLayoutConstraint.activate([
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    hostingController.didMove(toParent: self)
    }

}
