//
//  UserDTO.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Vapor

struct UserDTO: Content {
    let id: UUID
    let username: String
    
    init(user: User) {
        self.id = user.id!
        self.username = user.username
    }
}
