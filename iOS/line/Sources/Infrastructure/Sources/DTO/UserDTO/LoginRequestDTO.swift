//
//  LoginRequest.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct LoginRequestDTO: Equatable, Sendable, Codable {
    let email: String
    let password: String
}
