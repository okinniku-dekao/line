//
//  Email.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

public struct Email: Equatable, Hashable, Codable {
    let value: String
    
    public init(_ value: String) throws(DomainError) {
        guard !value.isEmpty else {
            throw DomainError.validation(.emptyEmail)
        }

        let components = value.components(separatedBy: "@")
        guard components.count == 2,
              !components[0].isEmpty,
              !components[1].isEmpty else {
            throw DomainError.validation(.invalidEmailFormat)
        }

        let domainComponents = components[1].components(separatedBy: ".")
        guard domainComponents.count >= 2,
              domainComponents.allSatisfy({ !$0.isEmpty }) else {
            throw DomainError.validation(.invalidEmailDomain)
        }

        guard let tld = domainComponents.last, tld.count >= 2 else {
            throw DomainError.validation(.invalidTopLevelDomain)
        }
        
        self.value = value
    }
}
