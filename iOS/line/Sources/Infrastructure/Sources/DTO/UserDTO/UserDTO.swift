//
//  UserDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct UserDTO: Equatable, Sendable, Codable {
    let id: UUID
    let email: String
}
