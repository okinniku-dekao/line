import Fluent
import FluentSQLiteDriver
import Vapor


public func configure(_ app: Application) async throws {
    // Database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    // Session
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)
    
    
    // Migrations
    app.migrations.add(CreateUser())
    try await app.autoMigrate()
    
    try routes(app)
}
