//
//  NetworkError.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidBaseURL
    case invalidAPIPath
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case noData
    case unauthorized
    case cancelled
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.invalidBaseURL, .invalidBaseURL),
            (.invalidAPIPath, .invalidAPIPath),
            (.invalidResponse, .invalidResponse),
            (.requestFailed, .requestFailed),
            (.noData, .noData),
            (.unauthorized, .unauthorized),
            (.cancelled, .cancelled):
            return true
        
        case let (.serverError(lStatusCode, lData), .serverError(rStatusCode, rData)):
            return lStatusCode == rStatusCode && lData == rData
            
        default:
            return false
            
        }
    }
}
