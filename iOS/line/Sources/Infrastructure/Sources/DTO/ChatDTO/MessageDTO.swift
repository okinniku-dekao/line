//
//  MessageDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct MessageDTO: Equatable, Sendable, Codable {
    let id: UUID
    let senderId: UUID
    let senderName: String
    let content: String
    let type: String
    let status: String
    let createdAt: Date?
}
