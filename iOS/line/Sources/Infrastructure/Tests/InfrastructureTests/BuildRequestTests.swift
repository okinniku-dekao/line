//
//  BuildRequestTests.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/08.
//

import Testing
@testable import Infrastructure

@Test("正常系：基本的なrequestが生成される")
func buildRequestBasic() throws {
    let request = try APIRequestMock().buildRequest()
    #expect(request.httpMethod == HTTPMethod.get.rawValue)
    #expect(request.timeoutInterval == 30)
    #expect(request.allHTTPHeaderFields == ["Content-Type": "application/json"])
}
