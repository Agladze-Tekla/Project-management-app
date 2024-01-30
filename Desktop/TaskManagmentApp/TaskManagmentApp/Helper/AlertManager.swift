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
