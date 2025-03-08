//
//  Password.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

public struct Password: Equatable {
    let value: String
    
    public init(_ value: String) throws(DomainError) {
        guard !value.isEmpty else { throw DomainError.validation(.emptyPassword) }
        guard value.count >= 8 else { throw DomainError.validation(.invalidPassword) }

        self.value = value
    }
}
