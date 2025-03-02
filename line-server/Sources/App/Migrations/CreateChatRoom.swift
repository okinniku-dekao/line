import Fluent

struct CreateChatRoom: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(ChatRoom.schema)
            .id()
            .field(ChatRoom.FieldKeys.name, .string)
            .field(ChatRoom.FieldKeys.type, .string, .required)
            .field(ChatRoom.FieldKeys.imageUrl, .string)
            .field(ChatRoom.FieldKeys.createdAt, .datetime)
            .field(ChatRoom.FieldKeys.updatedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(ChatRoom.schema).delete()
    }
}
