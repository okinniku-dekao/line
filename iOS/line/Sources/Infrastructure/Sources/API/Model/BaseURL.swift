//
//  BaseURL.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/07.
//

import Foundation

struct BaseURL: Equatable {
    let value: String
    
    init(value: String) throws {
        guard !value.isEmpty,
              (value.hasPrefix("https://") || value.hasPrefix("http://")) else {
            throw NetworkError.invalidBaseURL
        }
        
        // ホスト名のチェック
        guard let url = URL(string: value),
              let urlHost = url.host(),
              !urlHost.isEmpty else {
            throw NetworkError.invalidBaseURL
        }
        
        if value.hasSuffix("/") {
            self.value = String(value.dropLast())
        } else {
            self.value = value
        }
    }
}
