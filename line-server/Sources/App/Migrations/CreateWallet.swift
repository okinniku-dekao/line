import Fluent

struct CreateWallet: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Wallet.schema)
            .id()
            .field(Wallet.FieldKeys.userId, .uuid, .required, .references(User.schema, "id"))
            .field(Wallet.FieldKeys.balance, .double, .required)
            .field(Wallet.FieldKeys.points, .int, .required)
            .field(Wallet.FieldKeys.status, .string, .required)
            .field(Wallet.FieldKeys.createdAt, .datetime)
            .field(Wallet.FieldKeys.updatedAt, .datetime)
            .unique(on: Wallet.FieldKeys.userId)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Wallet.schema).delete()
    }
}
