//
//  LoginRequest.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct LoginRequest: APIRequest {
    typealias Response = AuthResponse

    var path: String = "api/auth/login"
    var method: HTTPMethod = .post
    var queryParameters: [String : String]? = nil
    var bodyParameters: (any Encodable)?
    
    init(loginRequestDTO: LoginRequestDTO) {
        self.bodyParameters = loginRequestDTO
    }
}
