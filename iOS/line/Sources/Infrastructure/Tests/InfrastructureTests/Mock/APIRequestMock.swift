//
//  APIRequestMock.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/08.
//

@testable import Infrastructure

struct ResponseMock: Codable {}

struct APIRequestMock: APIRequest {
    typealias Response = ResponseMock
    
    var baseURL: BaseURL {
        try! BaseURL(value: "https://mock.com")
    }
    var path: APIPath = try! .init(value: "/api/mock")
    var method: HTTPMethod = .get
    var queryParameters: [String : String]?
    var bodyParameters: (any Encodable)?
}
