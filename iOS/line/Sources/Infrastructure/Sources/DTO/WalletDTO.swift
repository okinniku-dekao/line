//
//  WalletDTO.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/02.
//

import Foundation

struct WalletDTO: Equatable, Sendable, Codable {
    let id: UUID
    let balance: Double
    let points: Int
    let status: String
}
