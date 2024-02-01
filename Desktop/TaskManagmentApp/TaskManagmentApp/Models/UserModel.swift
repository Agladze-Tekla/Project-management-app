//
//  UserModel.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/27/24.
//

import Foundation

struct RegisterUserRequest {
    let username: String
    let email: String
    let password: String
}

struct LoginUserRequest {
    let email: String
    let password: String
}

struct User {
    let username: String
    let email: String
    let userUID: String
}
