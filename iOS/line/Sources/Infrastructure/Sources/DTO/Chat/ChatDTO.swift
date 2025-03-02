//
//  ChatDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct ChatRoomDTO: Equatable, Sendable, Codable {
    let id: UUID
    let name: String?
    let type: String
    let imageUrl: String?
    let lastMessage: MessageDTO?
    let unreadCount: Int
    let createdAt: Date?
    let updatedAt: Date?
}
