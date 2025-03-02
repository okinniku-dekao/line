import Fluent

struct CreateTransaction: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Transaction.schema)
            .id()
            .field(Transaction.FieldKeys.walletId, .uuid, .required, .references(Wallet.schema, "id"))
            .field(Transaction.FieldKeys.amount, .double, .required)
            .field(Transaction.FieldKeys.type, .string, .required)
            .field(Transaction.FieldKeys.status, .string, .required)
            .field(Transaction.FieldKeys.description, .string)
            .field(Transaction.FieldKeys.merchantName, .string)
            .field(Transaction.FieldKeys.reference, .string)
            .field(Transaction.FieldKeys.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Transaction.schema).delete()
    }
}
