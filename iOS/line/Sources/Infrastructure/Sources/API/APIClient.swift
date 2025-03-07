//
//  APIExecutor.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

enum APIClient {
    static func execute<T: APIRequest>(_ request: T) async throws(NetworkError) -> T.Response {
        let session = URLSession.shared
        let request = try request.buildRequest()
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // レスポンスチェック
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // ステータスコードチェック
            switch httpResponse.statusCode {
            case 200...299:
                // 成功
                do {
                    return try JSONDecoder().decode(T.Response.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
