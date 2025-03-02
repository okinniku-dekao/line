import Vapor

struct ChatRoomDTO: Content {
    let id: UUID
    let name: String?
    let type: String
    let imageUrl: String?
    let lastMessage: MessageDTO?
    let unreadCount: Int
    let createdAt: Date?
    let updatedAt: Date?
    
    init(chatRoom: ChatRoom, lastMessage: Message? = nil, unreadCount: Int = 0) {
        self.id = chatRoom.id!
        self.name = chatRoom.name
        self.type = chatRoom.type.rawValue
        self.imageUrl = chatRoom.imageUrl
        self.lastMessage = lastMessage.map { MessageDTO(message: $0) }
        self.unreadCount = unreadCount
        self.createdAt = chatRoom.createdAt
        self.updatedAt = chatRoom.updatedAt
    }
}

struct ChatRoomListResponse: Content {
    let chatRooms: [ChatRoomDTO]
    let count: Int
    
    init(chatRooms: [ChatRoomDTO]) {
        self.chatRooms = chatRooms
        self.count = chatRooms.count
    }
}

struct CreateChatRoomRequest: Content {
    let name: String?
    let type: String
    let participantIds: [UUID]
}

struct MessageDTO: Content {
    let id: UUID
    let senderId: UUID
    let senderName: String
    let content: String
    let type: String
    let status: String
    let createdAt: Date?
    
    init(message: Message, senderName: String? = nil) {
        self.id = message.id!
        self.senderId = message.$sender.id
        self.senderName = senderName ?? "Unknown"
        self.content = message.content
        self.type = message.type.rawValue
        self.status = message.status.rawValue
        self.createdAt = message.createdAt
    }
}

struct MessageListResponse: Content {
    let messages: [MessageDTO]
    let count: Int
    
    init(messages: [MessageDTO]) {
        self.messages = messages
        self.count = messages.count
    }
}

struct SendMessageRequest: Content {
    let content: String
    let type: String
}

struct MessageStatusUpdateRequest: Content {
    let messageIds: [UUID]
    let status: String
}
