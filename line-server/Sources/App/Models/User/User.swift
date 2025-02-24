import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: FieldKeys.email)
    var email: String
    @Field(key: FieldKeys.userName)
    var userName: String
    @Field(key: FieldKeys.passwordHash)
    var passwordHash: String
    
    
    init() {}
    
    init(id: UUID? = nil, email: String, userName: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.userName = userName
        self.passwordHash = passwordHash
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey: KeyPath<User, Field<String>> = \User.$email
    static let passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
    
    static func authenticate(
        email: String,
        password: String,
        on db: Database
    ) async throws -> User {
        guard let user = try await User.query(on: db)
            .filter(\.$email == email)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        guard try user.verify(password: password) else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        return user
    }
}

extension User: SessionAuthenticatable {
    typealias SessionID = UUID
    
    var sessionID: UUID {
        self.id!
    }
}


// MARK: - Field Keys
extension User {
    enum FieldKeys {
        static let email: FieldKey = { "email" }()
        static let userName: FieldKey = { "user_name" }()
        static let passwordHash: FieldKey = { "password_hash" }()
    }
}
