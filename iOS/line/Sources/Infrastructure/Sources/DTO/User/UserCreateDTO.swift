//
//  UserCreateDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

struct UserCreateDTO: Equatable, Sendable, Codable {
    var email: String
    var userName: String
    var password: String
    var confirmPassword: String
}
