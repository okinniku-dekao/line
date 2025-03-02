import Vapor

struct FriendDTO: Content {
    let id: UUID
    let userName: String
    let status: String
    let createdAt: Date?
    
    init(friend: Friend, user: User) {
        self.id = friend.id!
        self.userName = user.userName
        self.status = friend.status.rawValue
        self.createdAt = friend.createdAt
    }
}

struct FriendListResponse: Content {
    let friends: [FriendDTO]
    let count: Int
    
    init(friends: [FriendDTO]) {
        self.friends = friends
        self.count = friends.count
    }
}

struct FriendRequest: Content {
    let friendId: UUID
}
