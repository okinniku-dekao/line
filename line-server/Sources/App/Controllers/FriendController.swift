import Fluent
import Vapor

struct FriendController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let friends = routes.grouped("api", "friends")
        friends.get(use: index)
        friends.post(use: create)
        friends.delete(":friendId", use: delete)
        friends.put(":friendId", "status", use: updateStatus)
    }
    
    @Sendable
    func index(req: Request) async throws -> FriendListResponse {
        let user = try req.auth.require(User.self)
        
        let friends = try await Friend.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$friend)
            .all()
        
        let friendDTOs = friends.map { friend in
            FriendDTO(friend: friend, user: friend.friend)
        }
        
        return FriendListResponse(friends: friendDTOs)
    }
    
    @Sendable
    func create(req: Request) async throws -> FriendDTO {
        let user = try req.auth.require(User.self)
        let friendRequest = try req.content.decode(FriendRequest.self)
        
        // ユーザーが自分自身を友達に追加しようとしていないか確認
        guard user.id! != friendRequest.friendId else {
            throw Abort(.badRequest, reason: "自分自身を友達に追加することはできません")
        }
        
        // 友達となるユーザーが存在するか確認
        guard let friendUser = try await User.find(friendRequest.friendId, on: req.db) else {
            throw Abort(.notFound, reason: "指定されたユーザーが見つかりません")
        }
        
        // すでに友達関係が存在するか確認
        let existingFriendship = try await Friend.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$friend.$id == friendRequest.friendId)
            .first()
        
        if existingFriendship != nil {
            throw Abort(.conflict, reason: "すでに友達関係が存在します")
        }
        
        // 友達関係を作成
        let friend = Friend(userId: user.id!, friendId: friendRequest.friendId, status: .pending)
        try await friend.save(on: req.db)
        
        return FriendDTO(friend: friend, user: friendUser)
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let friendId = req.parameters.get("friendId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効な友達IDです")
        }
        
        guard let friend = try await Friend.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$friend.$id == friendId)
            .first() else {
            throw Abort(.notFound, reason: "友達関係が見つかりません")
        }
        
        try await friend.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func updateStatus(req: Request) async throws -> FriendDTO {
        let user = try req.auth.require(User.self)
        guard let friendId = req.parameters.get("friendId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効な友達IDです")
        }
        
        struct StatusUpdateRequest: Content {
            let status: String
        }
        
        let statusUpdate = try req.content.decode(StatusUpdateRequest.self)
        guard let status = FriendStatus(rawValue: statusUpdate.status) else {
            throw Abort(.badRequest, reason: "無効なステータスです")
        }
        
        guard let friend = try await Friend.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$friend.$id == friendId)
            .with(\.$friend)
            .first() else {
            throw Abort(.notFound, reason: "友達関係が見つかりません")
        }
        
        friend.status = status
        try await friend.save(on: req.db)
        
        return FriendDTO(friend: friend, user: friend.friend)
    }
}
