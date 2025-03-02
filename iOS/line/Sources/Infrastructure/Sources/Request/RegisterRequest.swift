//
//  RegisterRequest.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

struct RegisterRequest: APIRequest {
    typealias Response = AuthResponse

    var path: String = "api/auth/register"
    var method: HTTPMethod = .post
    var queryParameters: [String : String]? = nil
    var bodyParameters: (any Encodable)?
    
    init(userCreate: UserCreateDTO) {
        self.bodyParameters = userCreate
    }
}
