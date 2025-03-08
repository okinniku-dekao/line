//
//  EmailTests.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

import Testing
@testable import Domain

@Test("正常系：メールアドレスが正常に初期化できる")
func emailBasic() throws {
    let email = try Email("test@example.com")
    #expect(email.value == "test@example.com")
}

@Test("正常系：メールアドレスが正常に初期化できる(数値あり)")
func emailBasicWithNumeric() throws {
    let email = try Email("test123@example.com")
    #expect(email.value == "test123@example.com")
}

@Test("異常系：メールアドレスが空")
func emailEmpty() throws {
    #expect(throws: DomainError.validation(.emptyEmail)) {
        try Email("")
    }
}

@Test(
    "異常系：メールアドレス形式が不正",
    arguments: [
        "test",
        "test@@example.com",
        "@example.com",
        "test@",
    ]
)
func emailInvalidFormat(email: String) throws {
    #expect(throws: DomainError.validation(.invalidEmailFormat)) {
        try Email(email)
    }
}

@Test(
    "異常系：ドメインが不正",
    arguments: [
        "test@example",
        "test@a.",
        "test@.",
        "test@.a"
    ]
)
func emailInvalidEmailDomain(email: String) throws {
    #expect(throws: DomainError.validation(.invalidEmailDomain)) {
        try Email(email)
    }
}

@Test(
    "異常系：トップレベルドメインが不正",
    arguments: [
        "test@example.c",
        "test@example.co.j",
    ]
)
func emailInvalidTopLevelDomain(email: String) throws {
    #expect(throws: DomainError.validation(.invalidTopLevelDomain)) {
        try Email(email)
    }
}
