import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "username")
    var username: String
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() {}
    
    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.username = passwordHash
    }
}

extension User {
    struct Create: Content {
        var username: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(8...))
    }
}


extension User: ModelAuthenticatable {
    static let usernameKey: KeyPath<User, Field<String>> = \User.$username
    static let passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
    
    static func authenticate(
        username: String,
        password: String,
        on db: Database
    ) async throws -> User {
        guard let user = try await User.query(on: db)
            .filter(\.$username == username)
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
