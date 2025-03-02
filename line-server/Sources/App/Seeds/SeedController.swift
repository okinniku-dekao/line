import Fluent
import Vapor
import Foundation

struct SeedController {
    static func seed(_ app: Application) async throws {
        try await seedUsers(app)
        try await seedFriendships(app)
        try await seedChatRooms(app)
        try await seedMessages(app)
        try await seedNews(app)
        try await seedWallets(app)
        try await seedTransactions(app)
        
        app.logger.info("シードデータの投入が完了しました")
    }
    
    private static func seedUsers(_ app: Application) async throws {
        let users = [
            User(
                email: "test@example.com",
                userName: "テストユーザー",
                passwordHash: try Bcrypt.hash("password123")
            ),
            User(
                email: "tanaka@example.com",
                userName: "田中太郎",
                passwordHash: try Bcrypt.hash("password123")
            ),
            User(
                email: "yamada@example.com",
                userName: "山田花子",
                passwordHash: try Bcrypt.hash("password123")
            ),
            User(
                email: "suzuki@example.com",
                userName: "鈴木一郎",
                passwordHash: try Bcrypt.hash("password123")
            ),
            User(
                email: "sato@example.com",
                userName: "佐藤次郎",
                passwordHash: try Bcrypt.hash("password123")
            )
        ]
        
        for user in users {
            try await user.save(on: app.db)
        }
        
        app.logger.info("ユーザーデータを \(users.count) 件投入しました")
    }
    
    private static func seedFriendships(_ app: Application) async throws {
        // ユーザー取得
        let users = try await User.query(on: app.db).all()
        guard users.count >= 5 else {
            app.logger.warning("友達関係を作成するためのユーザーが不足しています")
            return
        }
        
        // テストユーザーは他のすべてのユーザーと友達になる
        let testUser = users.first!
        
        // 友達関係を作成
        for i in 1..<users.count {
            let friend = users[i]
            
            // testUser -> friend (active 状態)
            let friendship1 = Friend(
                userId: testUser.id!,
                friendId: friend.id!,
                status: .active
            )
            try await friendship1.save(on: app.db)
            
            // friend -> testUser (active 状態)
            let friendship2 = Friend(
                userId: friend.id!,
                friendId: testUser.id!,
                status: .active
            )
            try await friendship2.save(on: app.db)
        }
        
        // ユーザー間の友達関係
        if users.count >= 3 {
            // users[1] -> users[2] (active 状態)
            let friendship1 = Friend(
                userId: users[1].id!,
                friendId: users[2].id!,
                status: .active
            )
            try await friendship1.save(on: app.db)
            
            // users[2] -> users[1] (active 状態)
            let friendship2 = Friend(
                userId: users[2].id!,
                friendId: users[1].id!,
                status: .active
            )
            try await friendship2.save(on: app.db)
        }
        
        app.logger.info("友達関係データを投入しました")
    }
    
    private static func seedChatRooms(_ app: Application) async throws {
        // ユーザー取得
        let users = try await User.query(on: app.db).all()
        guard users.count >= 5 else {
            app.logger.warning("チャットルームを作成するためのユーザーが不足しています")
            return
        }
        
        let testUser = users[0]
        
        // 個人チャット (テストユーザーと各ユーザー)
        for i in 1..<users.count {
            let friend = users[i]
            
            let chatRoom = ChatRoom(
                name: nil,
                type: .direct
            )
            try await chatRoom.save(on: app.db)
            
            // テストユーザーを追加
            let chatRoomUser1 = ChatRoomUser(
                chatRoomId: chatRoom.id!,
                userId: testUser.id!,
                isAdmin: true
            )
            try await chatRoomUser1.save(on: app.db)
            
            // 友達を追加
            let chatRoomUser2 = ChatRoomUser(
                chatRoomId: chatRoom.id!,
                userId: friend.id!,
                isAdmin: false
            )
            try await chatRoomUser2.save(on: app.db)
        }
        
        // グループチャット
        let groupChatRoom = ChatRoom(
            name: "みんなのグループ",
            type: .group,
            imageUrl: "https://example.com/group_image.jpg"
        )
        try await groupChatRoom.save(on: app.db)
        
        // 全ユーザーをグループに追加
        for (index, user) in users.enumerated() {
            let isAdmin = index == 0  // テストユーザーを管理者に
            let chatRoomUser = ChatRoomUser(
                chatRoomId: groupChatRoom.id!,
                userId: user.id!,
                isAdmin: isAdmin
            )
            try await chatRoomUser.save(on: app.db)
        }
        
        app.logger.info("チャットルームデータを投入しました")
    }
    
    private static func seedMessages(_ app: Application) async throws {
        // ユーザーとチャットルーム取得
        let users = try await User.query(on: app.db).all()
        let chatRooms = try await ChatRoom.query(on: app.db).all()
        
        guard !users.isEmpty && !chatRooms.isEmpty else {
            app.logger.warning("メッセージを作成するためのデータが不足しています")
            return
        }
        
        let testUser = users[0]
        let messageContents = [
            "こんにちは！",
            "元気ですか？",
            "今日は天気がいいですね",
            "明日の予定は何ですか？",
            "週末に遊びませんか？",
            "新しいカフェができたらしいですよ",
            "映画を見に行きませんか？",
            "おすすめの本はありますか？",
            "今度の休みはどうしますか？",
            "お昼ご飯一緒に食べませんか？"
        ]
        
        // 各チャットルームにメッセージを追加
        for chatRoom in chatRooms {
            // チャットルームの参加者を取得
            let participants = try await ChatRoomUser.query(on: app.db)
                .filter(\.$chatRoom.$id == chatRoom.id!)
                .with(\.$user)
                .all()
                .map { $0.user }
            
            guard !participants.isEmpty else { continue }
            
            // 最大10件のメッセージを追加
            let messageCount = min(10, messageContents.count)
            
            for i in 0..<messageCount {
                let sender = participants[i % participants.count]
                let content = messageContents[i]
                
                let message = Message(
                    senderId: sender.id!,
                    chatRoomId: chatRoom.id!,
                    content: content,
                    type: .text,
                    status: sender.id == testUser.id ? .sent : .read
                )
                try await message.save(on: app.db)
                
                // 間隔を空けて作成日時を設定
                if let createdAt = message.createdAt {
                    message.createdAt = createdAt.addingTimeInterval(-Double((messageCount - i) * 3600))
                    try await message.save(on: app.db)
                }
            }
        }
        
        app.logger.info("メッセージデータを投入しました")
    }
    
    private static func seedNews(_ app: Application) async throws {
        let newsList = [
            News(
                title: "LINE Payで新しいキャンペーン開始",
                content: "LINE Payでは、本日より新しいキャンペーンを開始します。期間中はポイント還元率が5倍になります。",
                imageUrl: "https://example.com/news/pay_campaign.jpg",
                url: "https://example.com/news/1",
                category: .general,
                publisher: "LINE公式",
                isPromoted: true,
                publishedAt: Date().addingTimeInterval(-3600 * 24)
            ),
            News(
                title: "新しいスタンプが登場",
                content: "人気キャラクターの新作スタンプが本日より配信開始されました。",
                imageUrl: "https://example.com/news/new_stamp.jpg",
                url: "https://example.com/news/2",
                category: .entertainment,
                publisher: "LINE STORE",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 48)
            ),
            News(
                title: "セキュリティ機能がアップデート",
                content: "LINEアプリのセキュリティ機能が強化されました。最新版へのアップデートをお勧めします。",
                imageUrl: "https://example.com/news/security.jpg",
                url: "https://example.com/news/3",
                category: .technology,
                publisher: "LINE Labs",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 72)
            ),
            News(
                title: "LINE証券、新サービス開始",
                content: "LINE証券が新しい投資サービスを開始しました。少額から始められる資産運用が可能です。",
                imageUrl: "https://example.com/news/securities.jpg",
                url: "https://example.com/news/4",
                category: .business,
                publisher: "LINE証券",
                isPromoted: true,
                publishedAt: Date().addingTimeInterval(-3600 * 96)
            ),
            News(
                title: "健康管理アプリと連携機能",
                content: "LINEアプリと健康管理アプリの連携機能が追加されました。",
                imageUrl: "https://example.com/news/health.jpg",
                url: "https://example.com/news/5",
                category: .health,
                publisher: "LINE Health",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 120)
            ),
            News(
                title: "スポーツニュース配信開始",
                content: "LINEニュースでスポーツ速報の配信を開始しました。",
                imageUrl: "https://example.com/news/sports.jpg",
                url: "https://example.com/news/6",
                category: .sports,
                publisher: "LINE NEWS",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 144)
            ),
            News(
                title: "宇宙探査の最新情報",
                content: "宇宙探査に関する最新の科学ニュースをお届けします。",
                imageUrl: "https://example.com/news/science.jpg",
                url: "https://example.com/news/7",
                category: .science,
                publisher: "Science News",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 168)
            ),
            News(
                title: "新作映画情報",
                content: "この夏公開予定の話題の映画情報をまとめてお届けします。",
                imageUrl: "https://example.com/news/movies.jpg",
                url: "https://example.com/news/8",
                category: .entertainment,
                publisher: "Entertainment Weekly",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 192)
            ),
            News(
                title: "LINE MUSIC新プラン登場",
                content: "LINE MUSICに家族割プランが新登場。お得に音楽を楽しめます。",
                imageUrl: "https://example.com/news/music.jpg",
                url: "https://example.com/news/9",
                category: .entertainment,
                publisher: "LINE MUSIC",
                isPromoted: true,
                publishedAt: Date().addingTimeInterval(-3600 * 216)
            ),
            News(
                title: "電子マネー利用可能店舗拡大",
                content: "LINE Payが利用できる店舗が全国でさらに拡大しました。",
                imageUrl: "https://example.com/news/stores.jpg",
                url: "https://example.com/news/10",
                category: .business,
                publisher: "LINE Pay",
                isPromoted: false,
                publishedAt: Date().addingTimeInterval(-3600 * 240)
            )
        ]
        
        for news in newsList {
            try await news.save(on: app.db)
        }
        
        app.logger.info("ニュースデータを \(newsList.count) 件投入しました")
    }
    
    private static func seedWallets(_ app: Application) async throws {
        // ユーザー取得
        let users = try await User.query(on: app.db).all()
        
        for user in users {
            let wallet = Wallet(
                userId: user.id!,
                balance: Double.random(in: 1000...50000).rounded(),
                points: Int.random(in: 100...2000),
                status: .active
            )
            try await wallet.save(on: app.db)
        }
        
        app.logger.info("ウォレットデータを \(users.count) 件投入しました")
    }
    
    private static func seedTransactions(_ app: Application) async throws {
        // ウォレット取得
        let wallets = try await Wallet.query(on: app.db).with(\.$user).all()
        
        guard !wallets.isEmpty else {
            app.logger.warning("トランザクションを作成するためのウォレットがありません")
            return
        }
        
        // 取引タイプ
        let transactionTypes: [TransactionType] = [
            .deposit, .withdrawal, .payment, .transfer, .refund, .pointsEarned, .pointsRedeemed
        ]
        
        // 店舗名
        let merchants = [
            "コンビニA", "スーパーB", "カフェC", "レストランD", "オンラインストアE",
            "ドラッグストアF", "書店G", "家電量販店H", "衣料品店I", "ガソリンスタンドJ"
        ]
        
        // 各ウォレットに取引履歴を追加
        for wallet in wallets {
            // 10件の取引履歴を追加
            for i in 0..<10 {
                let type = transactionTypes[i % transactionTypes.count]
                
                // 取引タイプに応じて金額を設定
                var amount: Double
                var description: String?
                var merchantName: String?
                var reference: String?
                
                switch type {
                case .deposit:
                    amount = Double.random(in: 1000...10000).rounded()
                    description = "チャージ"
                    reference = "クレジットカード"
                    
                case .withdrawal:
                    amount = -Double.random(in: 500...3000).rounded()
                    description = "引き出し"
                    reference = "銀行口座"
                    
                case .payment:
                    amount = -Double.random(in: 100...5000).rounded()
                    description = "支払い"
                    merchantName = merchants[Int.random(in: 0..<merchants.count)]
                    
                case .transfer:
                    amount = -Double.random(in: 100...3000).rounded()
                    description = "送金"
                    let receiverIndex = Int.random(in: 0..<wallets.count)
                    reference = wallets[receiverIndex].user.userName
                    
                case .refund:
                    amount = Double.random(in: 100...2000).rounded()
                    description = "返金"
                    merchantName = merchants[Int.random(in: 0..<merchants.count)]
                    
                case .pointsEarned:
                    amount = Double.random(in: 10...100).rounded()
                    description = "ポイント獲得"
                    merchantName = merchants[Int.random(in: 0..<merchants.count)]
                    
                case .pointsRedeemed:
                    amount = Double.random(in: 100...500).rounded()
                    description = "ポイント利用"
                }
                
                let transaction = Transaction(
                    walletId: wallet.id!,
                    amount: amount,
                    type: type,
                    status: .completed,
                    description: description,
                    merchantName: merchantName,
                    reference: reference
                )
                try await transaction.save(on: app.db)
                
                // 間隔を空けて作成日時を設定
                if let createdAt = transaction.createdAt {
                    transaction.createdAt = createdAt.addingTimeInterval(-Double((10 - i) * 86400))
                    try await transaction.save(on: app.db)
                }
            }
        }
        
        app.logger.info("トランザクションデータを投入しました")
    }
}
