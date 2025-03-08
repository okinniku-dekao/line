//
//  DomainError.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//

public enum DomainError: Error, Equatable {
    case validation(ValidationError)
    
    public var localizedDescription: String {
        switch self {
        case .validation(let error):
            return error.localizedDescription
        }
    }
}
