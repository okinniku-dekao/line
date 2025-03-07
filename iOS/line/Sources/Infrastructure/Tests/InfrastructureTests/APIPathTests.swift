//
//  API.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/07.
//

import Testing
@testable import Infrastructure

@Test("正常系：Path正常に設定される")
func apiPathBasic() throws {
    let path = try APIPath(value: "/api")
    #expect(path.value == "/api")
}

@Test("正常系：Path正常に設定される(先頭に/がつく)")
func apiPathBasicAddingPrefixSlash() throws {
    let path = try APIPath(value: "api")
    #expect(path.value == "/api")
}

@Test("異常系：空のpathが設定された")
func apiPathInvalidPathEmpty() throws {
    #expect(throws: NetworkError.invalidAPIPath) {
        try APIPath(value: "")
    }
}
