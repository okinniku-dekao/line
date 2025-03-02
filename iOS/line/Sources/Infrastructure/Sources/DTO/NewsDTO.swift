//
//  NewsDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct NewsDTO: Equatable, Sendable, Codable {
    let id: UUID
    let title: String
    let content: String
    let imageUrl: String?
    let url: String
    let category: String
    let publisher: String
    let isPromoted: Bool
    let publishedAt: Date?
}
