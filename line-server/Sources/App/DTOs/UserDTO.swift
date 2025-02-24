//
//  UserDTO.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Vapor

struct UserDTO: Content {
    let id: UUID
    let email: String
    
    init(user: User) {
        self.id = user.id!
        self.email = user.email
    }
}
