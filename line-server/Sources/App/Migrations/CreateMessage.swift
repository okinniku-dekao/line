import Fluent

struct CreateMessage: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Message.schema)
            .id()
            .field(Message.FieldKeys.senderId, .uuid, .required, .references(User.schema, "id"))
            .field(Message.FieldKeys.chatRoomId, .uuid, .required, .references(ChatRoom.schema, "id"))
            .field(Message.FieldKeys.content, .string, .required)
            .field(Message.FieldKeys.type, .string, .required)
            .field(Message.FieldKeys.status, .string, .required)
            .field(Message.FieldKeys.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(Message.schema).delete()
    }
}
