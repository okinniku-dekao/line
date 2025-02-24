//
//  LoginRequest.swift
//  line-server
//
//  Created by 東　秀斗 on 2025/02/19.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
