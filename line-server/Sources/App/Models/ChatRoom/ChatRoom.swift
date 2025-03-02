import Fluent
import Vapor

final class ChatRoom: Model, Content, @unchecked Sendable {
    static let schema = "chat_rooms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.name)
    var name: String?
    
    @Field(key: FieldKeys.type)
    var type: ChatRoomType
    
    @Field(key: FieldKeys.imageUrl)
    var imageUrl: String?
    
    @Children(for: \.$chatRoom)
    var messages: [Message]
    
    @Siblings(through: ChatRoomUser.self, from: \.$chatRoom, to: \.$user)
    var participants: [User]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String? = nil, type: ChatRoomType, imageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.imageUrl = imageUrl
    }
}

enum ChatRoomType: String, Codable {
    case direct
    case group
}

// MARK: - Field Keys
extension ChatRoom {
    enum FieldKeys {
        static let name: FieldKey = "name"
        static let type: FieldKey = "type"
        static let imageUrl: FieldKey = "image_url"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
