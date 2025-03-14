import Fluent
import FluentSQLiteDriver
import Vapor


public func configure(_ app: Application) async throws {
    // データベース
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    // セッション
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)
    
    // マイグレーション
    app.migrations.add(CreateUser())
    app.migrations.add(CreateFriend())
    app.migrations.add(CreateChatRoom())
    app.migrations.add(CreateChatRoomUser())
    app.migrations.add(CreateMessage())
    app.migrations.add(CreateNews())
    app.migrations.add(CreateWallet())
    app.migrations.add(CreateTransaction())
 
    try await app.autoMigrate()
    
    // コマンド
    app.commands.use(SeedCommand(), as: "seed")
    
    // ルーティング
    try routes(app)
}
