//
//  ValidationError.swift
//  Domain
//
//  Created by 東　秀斗 on 2025/03/08.
//


public enum ValidationError: Error, Equatable {
    case emptyEmail
    case invalidEmailFormat
    case invalidEmailDomain
    case invalidTopLevelDomain
    case emptyPassword
    case invalidPassword
    
    public var localizedDescription: String {
        switch self {
        case .emptyEmail:
            return "メールアドレスが入力されていません。"

        case .invalidEmailFormat,
                .invalidEmailDomain,
                .invalidTopLevelDomain:
            return "メールアドレスの形式が不正です。"
            
        case .emptyPassword:
            return "パスワードが入力されていません。"
            
        case .invalidPassword:
            return "パスワードの要件を満たしていません。"
        }
    }
}
