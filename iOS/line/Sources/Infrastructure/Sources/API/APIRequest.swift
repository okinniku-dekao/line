//
//  APIRequest.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Encodable? { get }
    var timeoutInterval: TimeInterval { get }
}

extension APIRequest {
    var baseURL: String {
        return "http://127.0.0.1:8080/"
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var timeoutInterval: TimeInterval {
        return 30.0
    }
    
    // URLの構築メソッド
    private func buildURL() throws(NetworkError) -> URL {
        var urlComponents = URLComponents(string: baseURL + path)
        
        // クエリパラメータの追加
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    // リクエストの構築メソッド
    func buildRequest() throws(NetworkError) -> URLRequest {
        let url = try buildURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        // ヘッダーの追加
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // ボディパラメータの追加
        if let bodyParameters = bodyParameters {
            do {
                request.httpBody = try JSONEncoder().encode(bodyParameters)
            } catch {
                throw NetworkError.requestFailed(error)
            }
        }
        
        return request
    }
}
