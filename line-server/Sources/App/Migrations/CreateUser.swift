//
//  CreateUser.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("password_hash", .string, .required)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
