//
//  AlertManager.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class AlertManager {
    private static func showBasicAlert(vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

//MARK: - SignIn Alerts
extension AlertManager {
    public static func showInvaliEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Invalid Email", message: "Please write a valid email.")
    }
    
    public static func showInvaliPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Invalid Password", message: "Please write a valid password.")
    }
    
    public static func showInvaliUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Invalid Username", message: "Please write a valid username.")
    }
}

//MARK: - Registration Errors
extension AlertManager {
    public static func showRegistrationAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Unknown Registration Error", message: nil)
    }
    
    public static func showRegistrationAlert(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
}

//MARK: - LogIn Alerts
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Unknown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

//MARK: - LogOut Alerts
extension AlertManager {
    public static func showLogOutError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

//MARK: - Fetching User Errors
extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    public static func showUnknownFetchingUserError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Unknown Error Fetching User", message: nil)
    }
}

//MARK: - Add New Project Alerts
extension AlertManager {
    public static func showNoProjectTitleAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Project has no title", message: "Please write a valid title.")
    }
    public static func showAddProjectError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Saving Project", message: "\(error.localizedDescription)")
    }
}

//MARK: - Add New Task Alerts
extension AlertManager {
    public static func showNoTaskTitleAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Task has no title", message: "Please write a valid title.")
    }
    public static func showAddTasktError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Saving Task", message: "\(error.localizedDescription)")
    }
    public static func showNoTaskDateAlert(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Task has no due date", message: "Please choose a valid date.")
    }
    public static func noChosenProjectAler(on vc: UIViewController) {
        self.showBasicAlert(vc: vc, title: "Not assigned to any projects", message: "Please choose a project to assign this task to.")
    }
}

//MARK: - Fetch Project Alerts
extension AlertManager {
    public static func showProjectFetchingError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Fetching Projects", message: "\(error.localizedDescription)")
    }
}

//MARK: - Fetch Tasks Alerts
extension AlertManager {
    public static func showTasksFetchingError(on vc: UIViewController, error: Error) {
        self.showBasicAlert(vc: vc, title: "Error Fetching Tasks", message: "\(error.localizedDescription)")
    }
}
