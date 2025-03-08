//
//  IAuthRepository.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

public protocol IAuthRepository {
    func register() async throws -> AuthResponse
    func login(email: Email, password: Password) async throws -> AuthResponse
}
