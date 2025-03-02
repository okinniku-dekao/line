import Vapor

func routes(_ app: Application) throws {
    // 認証
    try app.register(collection: AuthController())
    
    // 認証が必要なルート
    let protected = app.routes.grouped(User.sessionAuthenticator())
    
    // ユーザー情報
    protected.get("me") { req -> UserDTO in
        let user = try req.auth.require(User.self)
        return UserDTO(user: user)
    }
    
    // 友達
    try protected.register(collection: FriendController())
    
    // チャット
    try protected.register(collection: ChatController())
    
    // ニュース
    try protected.register(collection: NewsController())
    
    // ウォレット
    try protected.register(collection: WalletController())
}
