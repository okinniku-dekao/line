import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthController())
    
    // Protected routes
    let protected = app.routes.grouped(User.sessionAuthenticator())
    protected.get("me") { req -> UserDTO in
        let user = try req.auth.require(User.self)
        return UserDTO(user: user)
    }
}
