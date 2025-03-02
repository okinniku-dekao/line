import Fluent
import Vapor

struct ChatController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("api", "chats")
        
        // チャットルーム関連
        chats.get(use: listChatRooms)
        chats.post(use: createChatRoom)
        chats.get(":chatRoomId", use: getChatRoom)
        chats.delete(":chatRoomId", use: deleteChatRoom)
        
        // メッセージ関連
        chats.get(":chatRoomId", "messages", use: getMessages)
        chats.post(":chatRoomId", "messages", use: sendMessage)
        chats.put("messages", "status", use: updateMessageStatus)
    }
    
    // チャットルーム一覧取得
    @Sendable
    func listChatRooms(req: Request) async throws -> ChatRoomListResponse {
        let user = try req.auth.require(User.self)
        
        // ユーザーが参加しているチャットルームを取得
        let chatRoomUsers = try await ChatRoomUser.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$chatRoom)
            .all()
        
        // 各チャットルームの最新メッセージと未読数を取得
        var chatRoomDTOs: [ChatRoomDTO] = []
        
        for chatRoomUser in chatRoomUsers {
            let chatRoom = chatRoomUser.chatRoom
            
            // 最新メッセージを取得
            let lastMessage = try await Message.query(on: req.db)
                .filter(\.$chatRoom.$id == chatRoom.id!)
                .sort(\.$createdAt, .descending)
                .first()
            
            // 未読メッセージ数を取得
            var unreadCount = 0
            if let lastReadMessageId = chatRoomUser.lastReadMessageId {
                unreadCount = try await Message.query(on: req.db)
                    .filter(\.$chatRoom.$id == chatRoom.id!)
                    .filter(\.$id > lastReadMessageId)
                    .count()
            } else {
                unreadCount = try await Message.query(on: req.db)
                    .filter(\.$chatRoom.$id == chatRoom.id!)
                    .count()
            }
            
            chatRoomDTOs.append(ChatRoomDTO(chatRoom: chatRoom, lastMessage: lastMessage, unreadCount: unreadCount))
        }
        
        // 最新メッセージの時間でソート
        chatRoomDTOs.sort { room1, room2 in
            let date1 = room1.lastMessage?.createdAt ?? room1.createdAt
            let date2 = room2.lastMessage?.createdAt ?? room2.createdAt
            return date1 ?? Date.distantPast > date2 ?? Date.distantPast
        }
        
        return ChatRoomListResponse(chatRooms: chatRoomDTOs)
    }
    
    // チャットルーム作成
    @Sendable
    func createChatRoom(req: Request) async throws -> ChatRoomDTO {
        let user = try req.auth.require(User.self)
        let createRequest = try req.content.decode(CreateChatRoomRequest.self)
        
        // チャットルームタイプのバリデーション
        guard let type = ChatRoomType(rawValue: createRequest.type) else {
            throw Abort(.badRequest, reason: "無効なチャットルームタイプです")
        }
        
        // 参加者が存在するか確認
        let participantIds = createRequest.participantIds
        guard !participantIds.isEmpty else {
            throw Abort(.badRequest, reason: "参加者を少なくとも1人指定してください")
        }
        
        // 自分を含む全参加者が存在するか確認
        let allParticipantIds = Array(Set(participantIds + [user.id!]))
        let participants = try await User.query(on: req.db)
            .filter(\.$id ~~ allParticipantIds)
            .all()
        
        guard participants.count == allParticipantIds.count else {
            throw Abort(.badRequest, reason: "一部の参加者が見つかりません")
        }
        
        // チャットルーム作成
        let chatRoom = ChatRoom(
            name: createRequest.name,
            type: type
        )
        try await chatRoom.save(on: req.db)
        
        // 参加者を追加
        for participant in participants {
            let isAdmin = participant.id == user.id
            let chatRoomUser = ChatRoomUser(
                chatRoomId: chatRoom.id!,
                userId: participant.id!,
                isAdmin: isAdmin
            )
            try await chatRoomUser.save(on: req.db)
        }
        
        return ChatRoomDTO(chatRoom: chatRoom)
    }
    
    // チャットルーム詳細取得
    @Sendable
    func getChatRoom(req: Request) async throws -> ChatRoomDTO {
        let user = try req.auth.require(User.self)
        guard let chatRoomId = req.parameters.get("chatRoomId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効なチャットルームIDです")
        }
        
        // チャットルーム取得とユーザーがそのルームに参加しているか確認
        guard let chatRoomUser = try await ChatRoomUser.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$chatRoom.$id == chatRoomId)
            .with(\.$chatRoom)
            .first() else {
            throw Abort(.notFound, reason: "チャットルームが見つからないか、アクセス権限がありません")
        }
        
        let chatRoom = chatRoomUser.chatRoom
        
        // 最新メッセージを取得
        let lastMessage = try await Message.query(on: req.db)
            .filter(\.$chatRoom.$id == chatRoom.id!)
            .sort(\.$createdAt, .descending)
            .first()
        
        // 未読メッセージ数を取得
        var unreadCount = 0
        if let lastReadMessageId = chatRoomUser.lastReadMessageId {
            unreadCount = try await Message.query(on: req.db)
                .filter(\.$chatRoom.$id == chatRoom.id!)
                .filter(\.$id > lastReadMessageId)
                .count()
        } else {
            unreadCount = try await Message.query(on: req.db)
                .filter(\.$chatRoom.$id == chatRoom.id!)
                .count()
        }
        
        return ChatRoomDTO(chatRoom: chatRoom, lastMessage: lastMessage, unreadCount: unreadCount)
    }
    
    // チャットルーム削除
    @Sendable
    func deleteChatRoom(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let chatRoomId = req.parameters.get("chatRoomId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効なチャットルームIDです")
        }
        
        // ユーザーがチャットルームの管理者かどうか確認
        guard let _ = try await ChatRoomUser.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$chatRoom.$id == chatRoomId)
            .filter(\.$isAdmin == true)
            .first() else {
            throw Abort(.forbidden, reason: "このチャットルームを削除する権限がありません")
        }
        
        // チャットルームを取得
        guard let chatRoom = try await ChatRoom.find(chatRoomId, on: req.db) else {
            throw Abort(.notFound, reason: "チャットルームが見つかりません")
        }
        
        // チャットルーム削除（カスケード削除でメッセージと参加者も削除される）
        try await chatRoom.delete(on: req.db)
        
        return .noContent
    }
    
    // メッセージ一覧取得
    @Sendable
    func getMessages(req: Request) async throws -> MessageListResponse {
        let user = try req.auth.require(User.self)
        guard let chatRoomId = req.parameters.get("chatRoomId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効なチャットルームIDです")
        }
        
        // ユーザーがそのチャットルームに参加しているか確認
        guard let chatRoomUser = try await ChatRoomUser.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$chatRoom.$id == chatRoomId)
            .first() else {
            throw Abort(.forbidden, reason: "このチャットルームにアクセスする権限がありません")
        }
        
        // 最新の既読メッセージIDを更新
        let latestMessage = try await Message.query(on: req.db)
            .filter(\.$chatRoom.$id == chatRoomId)
            .sort(\.$createdAt, .descending)
            .first()
        
        if let latestMessage = latestMessage {
            chatRoomUser.lastReadMessageId = latestMessage.id
            try await chatRoomUser.save(on: req.db)
        }
        
        // ページネーション用のパラメータ
        let limit = req.query[Int.self, at: "limit"] ?? 50
        let page = req.query[Int.self, at: "page"] ?? 1
        
        // メッセージを取得（最新順）
        let messages = try await Message.query(on: req.db)
            .filter(\.$chatRoom.$id == chatRoomId)
            .with(\.$sender)
            .sort(\.$createdAt, .descending)
            .paginate(PageRequest(page: page, per: limit))
            .items
        
        // DTOに変換
        let messageDTOs = messages.map { message in
            MessageDTO(message: message, senderName: message.sender.userName)
        }
        
        return MessageListResponse(messages: messageDTOs)
    }
    
    // メッセージ送信
    @Sendable
    func sendMessage(req: Request) async throws -> MessageDTO {
        let user = try req.auth.require(User.self)
        guard let chatRoomId = req.parameters.get("chatRoomId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効なチャットルームIDです")
        }
        let messageRequest = try req.content.decode(SendMessageRequest.self)
        
        // ユーザーがそのチャットルームに参加しているか確認
        guard let _ = try await ChatRoomUser.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$chatRoom.$id == chatRoomId)
            .first() else {
            throw Abort(.forbidden, reason: "このチャットルームにメッセージを送信する権限がありません")
        }
        
        // メッセージタイプのバリデーション
        guard let type = MessageType(rawValue: messageRequest.type) else {
            throw Abort(.badRequest, reason: "無効なメッセージタイプです")
        }
        
        // メッセージを作成
        let message = Message(
            senderId: user.id!,
            chatRoomId: chatRoomId,
            content: messageRequest.content,
            type: type
        )
        try await message.save(on: req.db)
        
        // チャットルームの最終更新時間を更新
        if let chatRoom = try await ChatRoom.find(chatRoomId, on: req.db) {
            chatRoom.updatedAt = Date()
            try await chatRoom.save(on: req.db)
        }
        
        return MessageDTO(message: message, senderName: user.userName)
    }
    
    // メッセージステータス更新
    @Sendable
    func updateMessageStatus(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let statusRequest = try req.content.decode(MessageStatusUpdateRequest.self)
        
        // ステータスのバリデーション
        guard let status = MessageStatus(rawValue: statusRequest.status) else {
            throw Abort(.badRequest, reason: "無効なメッセージステータスです")
        }
        
        // メッセージが存在し、ユーザーがそのチャットルームに参加しているか確認
        for messageId in statusRequest.messageIds {
            guard let message = try await Message.find(messageId, on: req.db) else {
                continue // メッセージが見つからない場合はスキップ
            }
            
            let chatRoomId = message.$chatRoom.id
            
            // ユーザーがそのチャットルームに参加しているか確認
            guard let _ = try await ChatRoomUser.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .filter(\.$chatRoom.$id == chatRoomId)
                .first() else {
                continue // 参加していない場合はスキップ
            }
            
            // メッセージステータスを更新
            message.status = status
            try await message.save(on: req.db)
        }
        
        return .ok
    }
}
