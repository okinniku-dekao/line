//
//  FriendDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct FriendDTO: Equatable, Sendable, Codable {
    let id: UUID
    let userName: String
    let status: String
    let createdAt: Date?
}
