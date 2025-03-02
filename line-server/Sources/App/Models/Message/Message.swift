import Fluent
import Vapor

final class Message: Model, Content, @unchecked Sendable {
    static let schema = "messages"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.senderId)
    var sender: User
    
    @Parent(key: FieldKeys.chatRoomId)
    var chatRoom: ChatRoom
    
    @Field(key: FieldKeys.content)
    var content: String
    
    @Field(key: FieldKeys.type)
    var type: MessageType
    
    @Field(key: FieldKeys.status)
    var status: MessageStatus
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, senderId: UUID, chatRoomId: UUID, content: String, type: MessageType = .text, status: MessageStatus = .sent) {
        self.id = id
        self.$sender.id = senderId
        self.$chatRoom.id = chatRoomId
        self.content = content
        self.type = type
        self.status = status
    }
}

enum MessageType: String, Codable {
    case text
    case image
    case video
    case audio
    case sticker
    case location
    case file
}

enum MessageStatus: String, Codable {
    case sent
    case delivered
    case read
}

// MARK: - Field Keys
extension Message {
    enum FieldKeys {
        static let senderId: FieldKey = "sender_id"
        static let chatRoomId: FieldKey = "chat_room_id"
        static let content: FieldKey = "content"
        static let type: FieldKey = "type"
        static let status: FieldKey = "status"
        static let createdAt: FieldKey = "created_at"
    }
}
