import Fluent

struct CreateChatRoomUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(ChatRoomUser.schema)
            .id()
            .field(ChatRoomUser.FieldKeys.chatRoomId, .uuid, .required, .references(ChatRoom.schema, "id"))
            .field(ChatRoomUser.FieldKeys.userId, .uuid, .required, .references(User.schema, "id"))
            .field(ChatRoomUser.FieldKeys.nickname, .string)
            .field(ChatRoomUser.FieldKeys.isAdmin, .bool, .required)
            .field(ChatRoomUser.FieldKeys.lastReadMessageId, .uuid)
            .field(ChatRoomUser.FieldKeys.joinedAt, .datetime)
            .unique(on: ChatRoomUser.FieldKeys.chatRoomId, ChatRoomUser.FieldKeys.userId)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(ChatRoomUser.schema).delete()
    }
}
