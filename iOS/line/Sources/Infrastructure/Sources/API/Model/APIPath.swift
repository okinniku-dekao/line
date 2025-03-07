//
//  APIPath.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/07.
//


struct APIPath: Equatable {
    let value: String
    
    init(value: String) throws {
        guard !value.isEmpty else { throw NetworkError.invalidAPIPath }
        
        if value.hasPrefix("/") {
            self.value = value
        } else {
            self.value = "/\(value)"
        }
    }
}
