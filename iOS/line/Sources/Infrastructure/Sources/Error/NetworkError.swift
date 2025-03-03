//
//  NetworkError.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case noData
    case unauthorized
}
