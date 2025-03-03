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

public func loginTest() async throws -> AuthResponse {
    let login = LoginRequestDTO(email: "test@example.com", password: "password123")
    return try await LoginRequest(loginRequestDTO: login).execute()
}
