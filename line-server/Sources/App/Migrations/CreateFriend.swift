import Fluent

struct CreateFriend: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Friend.schema)
            .id()
            .field(Friend.FieldKeys.userId, .uuid, .required, .references(User.schema, "id"))
            .field(Friend.FieldKeys.friendId, .uuid, .required, .references(User.schema, "id"))
            .field(Friend.FieldKeys.status, .string, .required)
            .field(Friend.FieldKeys.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Friend.schema).delete()
    }
}
