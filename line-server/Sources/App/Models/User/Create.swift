//
//  Create.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/22.
//
import Fluent
import Vapor

extension User {
    struct Create: Content {
        var email: String
        var userName: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(FieldKeys.email, as: String.self, is: !.empty && .email)
        validations.add(FieldKeys.userName, as: String.self, is: !.empty)
        validations.add(FieldKeys.password, as: String.self, is: .count(8...))
    }
}

extension User.Create {
    enum FieldKeys {
        static let email: ValidationKey = { "email" }()
        static let userName: ValidationKey = { "userName" }()
        static let password: ValidationKey = { "password" }()
        static let confirmPassword: ValidationKey = { "confirm_password" }()
    }
}
