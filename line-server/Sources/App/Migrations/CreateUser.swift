//
//  CreateUser.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field(User.FieldKeys.email, .string, .required)
            .field(User.FieldKeys.userName, .string, .required)
            .field(User.FieldKeys.passwordHash, .string, .required)
            .unique(on: User.FieldKeys.email)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
