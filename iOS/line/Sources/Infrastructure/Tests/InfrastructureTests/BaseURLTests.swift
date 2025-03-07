//
//  BaseURLTests.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/07.
//

import Testing
@testable import Infrastructure

@Test("正常系：正しいbaseUrlが設定される(https)")
func baseURLBasicHTTPS() throws {
    let baseURL = try BaseURL(value: "https://exmple.com")
    #expect(baseURL.value == "https://exmple.com")
}

@Test("正常系：正しいbaseUrlが設定される(http)")
func baseURLBasicHTTP() throws {
    let baseURL = try BaseURL(value: "http://exmple.com")
    #expect(baseURL.value == "http://exmple.com")
}

@Test("正常系：正しいbaseUrlが設定される(末尾の/が削除される)")
func baseURLBasicDropLastSlash() throws {
    let baseURL = try BaseURL(value: "https://exmple.com/")
    #expect(baseURL.value == "https://exmple.com")
}

@Test("異常系：空のBaseURLが設定された")
func baseURLInvalidEmpty() throws {
    #expect(throws: NetworkError.invalidBaseURL) {
        try BaseURL(value: "")
    }
}

@Test("異常系：(http/https以外)")
func baseURLInvalidProtocol() throws {
    #expect(throws: NetworkError.invalidBaseURL) {
        try BaseURL(value: "ftp://example.com")
    }
}

@Test("異常系：無効な文字列")
func baseURLInvalidLiteral() throws {
    #expect(throws: NetworkError.invalidBaseURL) {
        try BaseURL(value: "invalid_url")
    }
}

@Test("異常系：ホスト名が未指定")
func baseURLInvalidHostName() throws {
    #expect(throws: NetworkError.invalidBaseURL) {
        try BaseURL(value: "https://")
    }
}
