//
//  AuthResponse.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct AuthResponse: Codable {
    let user: UserDTO
    let message: String
}
