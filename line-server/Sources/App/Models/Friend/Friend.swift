import Fluent
import Vapor

final class Friend: Model, Content, @unchecked Sendable {
    static let schema = "friends"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.userId)
    var user: User
    
    @Parent(key: FieldKeys.friendId)
    var friend: User
    
    @Field(key: FieldKeys.status)
    var status: FriendStatus
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, friendId: UUID, status: FriendStatus = .active) {
        self.id = id
        self.$user.id = userId
        self.$friend.id = friendId
        self.status = status
    }
}

enum FriendStatus: String, Codable {
    case pending
    case active
    case blocked
}

// MARK: - Field Keys
extension Friend {
    enum FieldKeys {
        static let userId: FieldKey = "user_id"
        static let friendId: FieldKey = "friend_id"
        static let status: FieldKey = "status"
        static let createdAt: FieldKey = "created_at"
    }
}
