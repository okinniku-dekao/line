import Fluent
import Vapor

final class ChatRoomUser: Model, @unchecked Sendable {
    static let schema = "chat_room_users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.chatRoomId)
    var chatRoom: ChatRoom
    
    @Parent(key: FieldKeys.userId)
    var user: User
    
    @Field(key: FieldKeys.nickname)
    var nickname: String?
    
    @Field(key: FieldKeys.isAdmin)
    var isAdmin: Bool
    
    @Field(key: FieldKeys.lastReadMessageId)
    var lastReadMessageId: UUID?
    
    @Timestamp(key: FieldKeys.joinedAt, on: .create)
    var joinedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, chatRoomId: UUID, userId: UUID, nickname: String? = nil, isAdmin: Bool = false, lastReadMessageId: UUID? = nil) {
        self.id = id
        self.$chatRoom.id = chatRoomId
        self.$user.id = userId
        self.nickname = nickname
        self.isAdmin = isAdmin
        self.lastReadMessageId = lastReadMessageId
    }
}

// MARK: - Field Keys
extension ChatRoomUser {
    enum FieldKeys {
        static let chatRoomId: FieldKey = "chat_room_id"
        static let userId: FieldKey = "user_id"
        static let nickname: FieldKey = "nickname"
        static let isAdmin: FieldKey = "is_admin"
        static let lastReadMessageId: FieldKey = "last_read_message_id"
        static let joinedAt: FieldKey = "joined_at"
    }
}
