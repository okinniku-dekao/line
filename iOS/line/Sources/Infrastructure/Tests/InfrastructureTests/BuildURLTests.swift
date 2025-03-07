//
//  BuildURLTests.swift
//  Infrastructure
//
//  Created by 東　秀斗 on 2025/03/08.
//

import Testing
import Foundation
@testable import Infrastructure

@Test("正常系：基本的なURLが生成される")
func buildURLBasic() throws {
    let request = APIRequestMock()
    #expect(try request.buildURL() == URL(string: "https://mock.com/api/mock"))
}

@Test(
    "正常系：クエリパラメータが設定される(特殊文字もエスケープされる)",
    arguments: zip(
        [
            "hello world",
            "+&?=/#",
            "こんにちは"
        ],
        [
            "hello%20world",
            "+%26?%3D/%23",
            "%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF"
        ]
    )
)
func buildURLBasicQueryParams(
    query: String,
    expected: String
) throws {
    var request = APIRequestMock()
    request.queryParameters = [
        "query": query
    ]
    #expect(try request.buildURL() == URL(string: "https://mock.com/api/mock?query=\(expected)"))
}
