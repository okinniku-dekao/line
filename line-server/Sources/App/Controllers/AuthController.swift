//
//  AuthController.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRoutes = routes.grouped("api", "auth")
        authRoutes.post("register", use: register)
        authRoutes.post("login", use: login)
        authRoutes.post("logout", use: logout)
    }
    
    @Sendable
    func register(req: Request) async throws -> AuthResponse {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        let user = try User(
            email: create.email,
            userName: create.userName,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        
        return AuthResponse(
            user: UserDTO(user: user),
            message: "Registration successful"
        )
    }
    
    @Sendable
    func login(req: Request) async throws -> AuthResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)
        let user = try await User.authenticate(
            email: loginRequest.email,
            password: loginRequest.password,
            on: req.db
        )
        
        req.session.authenticate(user)
        return AuthResponse(
            user: UserDTO(user: user),
            message: "Login successful"
        )
    }
    
    @Sendable
    func logout(req: Request) async throws -> AuthResponse {
        let user = try req.auth.require(User.self)
        req.session.unauthenticate(User.self)
        return AuthResponse(
            user: UserDTO(user: user),
            message: "Logout successful"
        )
    }
}
