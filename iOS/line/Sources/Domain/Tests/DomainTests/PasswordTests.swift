//
//  PasswordTests.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

import Testing
@testable import Domain

@Test("正常系：パスワードが正常に初期化できる")
func passwordBasic() throws {
    let password = try Password("abcdefghij")
    #expect(password.value == "abcdefghij")
}

@Test("正常系：パスワードが正常に初期化できる(数値つき)")
func passwordBasicWithNumerics() throws {
    let password = try Password("abcdefghij123")
    #expect(password.value == "abcdefghij123")
}

@Test("正常系：パスワードが正常に初期化できる(特殊文字あり)")
func passwordBasicWithSpecial() throws {
    let password = try Password("abcdefghij@+/#$")
    #expect(password.value == "abcdefghij@+/#$")
}

@Test("異常系：パスワードが空")
func passwordEmpty() throws {
    #expect(throws: DomainError.validation(.emptyPassword)) {
        try Password("")
    }
}

@Test("異常系：パスワードの文字数不足")
func passwordInvalid() throws {
    #expect(throws: DomainError.validation(.invalidPassword)) {
        try Password("abc123")
    }
}
