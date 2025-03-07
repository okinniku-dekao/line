//
//  RegisterRequest.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

struct RegisterRequest: APIRequest {
    typealias Response = AuthResponse

    var path: APIPath
    var method: HTTPMethod = .post
    var queryParameters: [String : String]? = nil
    var bodyParameters: (any Encodable)?
    
    init(userCreate: UserCreateDTO) throws {
        self.bodyParameters = userCreate
        self.path = try .init(value: "api/auth/register")
    }
}
