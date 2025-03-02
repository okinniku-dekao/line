import Fluent
import Vapor

struct WalletController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let wallet = routes.grouped("api", "wallet")
        wallet.get(use: getWallet)
        wallet.get("transactions", use: getTransactions)
        wallet.post("topup", use: topUp)
        wallet.post("transfer", use: transfer)
        wallet.post("payment", use: makePayment)
        wallet.post("points", "redeem", use: redeemPoints)
    }
    
    // ウォレット情報取得
    @Sendable
    func getWallet(req: Request) async throws -> WalletDTO {
        let user = try req.auth.require(User.self)
        
        // ユーザーのウォレットを取得
        let wallet = try await Wallet.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .first()
        
        // ウォレットが存在しない場合は新しく作成
        if let wallet = wallet {
            return WalletDTO(wallet: wallet)
        } else {
            let newWallet = Wallet(userId: user.id!)
            try await newWallet.save(on: req.db)
            return WalletDTO(wallet: newWallet)
        }
    }
    
    // トランザクション履歴取得
    @Sendable
    func getTransactions(req: Request) async throws -> TransactionListResponse {
        let user = try req.auth.require(User.self)
        
        // ユーザーのウォレットを取得
        guard let wallet = try await Wallet.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .first() else {
            throw Abort(.notFound, reason: "ウォレットが見つかりません")
        }
        
        // ページネーション用のパラメータ
        let limit = req.query[Int.self, at: "limit"] ?? 20
        let page = req.query[Int.self, at: "page"] ?? 1
        
        // トランザクション履歴を取得
        let transactions = try await Transaction.query(on: req.db)
            .filter(\.$wallet.$id == wallet.id!)
            .sort(\.$createdAt, .descending)
            .paginate(PageRequest(page: page, per: limit))
            .items
        
        // DTOに変換
        let transactionDTOs = transactions.map { TransactionDTO(transaction: $0) }
        
        return TransactionListResponse(transactions: transactionDTOs)
    }
    
    // ウォレットチャージ
    @Sendable
    func topUp(req: Request) async throws -> TransactionDTO {
        let user = try req.auth.require(User.self)
        let topUpRequest = try req.content.decode(TopUpRequest.self)
        
        // 金額の検証
        guard topUpRequest.amount > 0 else {
            throw Abort(.badRequest, reason: "チャージ金額は0より大きい必要があります")
        }
        
        // ユーザーのウォレットを取得または作成
        let wallet = try await getOrCreateWallet(for: user.id!, on: req.db)
        
        // トランザクションを作成
        let transaction = Transaction(
            walletId: wallet.id!,
            amount: topUpRequest.amount,
            type: .deposit,
            description: "ウォレットチャージ",
            merchantName: "LINE Pay",
            reference: topUpRequest.paymentMethod
        )
        try await transaction.save(on: req.db)
        
        // ウォレット残高を更新
        wallet.balance += topUpRequest.amount
        try await wallet.save(on: req.db)
        
        return TransactionDTO(transaction: transaction)
    }
    
    // 送金
    @Sendable
    func transfer(req: Request) async throws -> TransactionDTO {
        let user = try req.auth.require(User.self)
        let transferRequest = try req.content.decode(TransferRequest.self)
        
        // 金額の検証
        guard transferRequest.amount > 0 else {
            throw Abort(.badRequest, reason: "送金額は0より大きい必要があります")
        }
        
        // 送金先のユーザーが存在するか確認
        guard let recipient = try await User.find(transferRequest.recipientId, on: req.db) else {
            throw Abort(.notFound, reason: "送金先のユーザーが見つかりません")
        }
        
        // 自分自身への送金をブロック
        guard user.id! != recipient.id! else {
            throw Abort(.badRequest, reason: "自分自身に送金することはできません")
        }
        
        // 送金元のウォレットを取得
        let senderWallet = try await getOrCreateWallet(for: user.id!, on: req.db)
        
        // 残高不足チェック
        guard senderWallet.balance >= transferRequest.amount else {
            throw Abort(.badRequest, reason: "残高不足です")
        }
        
        // 送金先のウォレットを取得または作成
        let recipientWallet = try await getOrCreateWallet(for: recipient.id!, on: req.db)
        
        // トランザクションを開始
        return try await req.db.transaction { database in
            // 送金元のトランザクションを作成
            let senderTransaction = Transaction(
                walletId: senderWallet.id!,
                amount: -transferRequest.amount,
                type: .transfer,
                description: transferRequest.description ?? "送金",
                reference: recipient.userName
            )
            try await senderTransaction.save(on: database)
            
            // 送金先のトランザクションを作成
            let recipientTransaction = Transaction(
                walletId: recipientWallet.id!,
                amount: transferRequest.amount,
                type: .transfer,
                description: transferRequest.description ?? "送金を受け取りました",
                reference: user.userName
            )
            try await recipientTransaction.save(on: database)
            
            // 送金元の残高を更新
            senderWallet.balance -= transferRequest.amount
            try await senderWallet.save(on: database)
            
            // 送金先の残高を更新
            recipientWallet.balance += transferRequest.amount
            try await recipientWallet.save(on: database)
            
            return TransactionDTO(transaction: senderTransaction)
        }
    }
    
    // 支払い
    @Sendable
    func makePayment(req: Request) async throws -> TransactionDTO {
        let user = try req.auth.require(User.self)
        let paymentRequest = try req.content.decode(PaymentRequest.self)
        
        // 金額の検証
        guard paymentRequest.amount > 0 else {
            throw Abort(.badRequest, reason: "支払い金額は0より大きい必要があります")
        }
        
        // ユーザーのウォレットを取得
        let wallet = try await getOrCreateWallet(for: user.id!, on: req.db)
        
        // 残高不足チェック
        guard wallet.balance >= paymentRequest.amount else {
            throw Abort(.badRequest, reason: "残高不足です")
        }
        
        // トランザクションを作成
        let transaction = Transaction(
            walletId: wallet.id!,
            amount: -paymentRequest.amount,
            type: .payment,
            description: "支払い",
            merchantName: paymentRequest.merchantName,
            reference: paymentRequest.reference
        )
        try await transaction.save(on: req.db)
        
        // ウォレット残高を更新
        wallet.balance -= paymentRequest.amount
        
        // ポイント付与（支払い金額の1%）
        let pointsEarned = Int(paymentRequest.amount * 0.01)
        if pointsEarned > 0 {
            wallet.points += pointsEarned
            
            // ポイント獲得トランザクションを作成
            let pointsTransaction = Transaction(
                walletId: wallet.id!,
                amount: Double(pointsEarned),
                type: .pointsEarned,
                description: "支払いによるポイント獲得",
                merchantName: paymentRequest.merchantName
            )
            try await pointsTransaction.save(on: req.db)
        }
        
        try await wallet.save(on: req.db)
        
        return TransactionDTO(transaction: transaction)
    }
    
    // ポイント利用
    @Sendable
    func redeemPoints(req: Request) async throws -> TransactionDTO {
        let user = try req.auth.require(User.self)
        
        struct RedeemPointsRequest: Content {
            let points: Int
        }
        
        let redeemRequest = try req.content.decode(RedeemPointsRequest.self)
        
        // ポイント数の検証
        guard redeemRequest.points > 0 else {
            throw Abort(.badRequest, reason: "利用ポイント数は0より大きい必要があります")
        }
        
        // ユーザーのウォレットを取得
        let wallet = try await getOrCreateWallet(for: user.id!, on: req.db)
        
        // ポイント不足チェック
        guard wallet.points >= redeemRequest.points else {
            throw Abort(.badRequest, reason: "ポイント不足です")
        }
        
        // ポイントを現金に変換（1ポイント = 1円）
        let amount = Double(redeemRequest.points)
        
        // トランザクションを作成
        let transaction = Transaction(
            walletId: wallet.id!,
            amount: amount,
            type: .pointsRedeemed,
            description: "ポイント利用"
        )
        try await transaction.save(on: req.db)
        
        // ウォレット残高とポイントを更新
        wallet.balance += amount
        wallet.points -= redeemRequest.points
        try await wallet.save(on: req.db)
        
        return TransactionDTO(transaction: transaction)
    }
    
    // ユーティリティ関数：ウォレットを取得または作成
    private func getOrCreateWallet(for userId: UUID, on database: Database) async throws -> Wallet {
        if let wallet = try await Wallet.query(on: database)
            .filter(\.$user.$id == userId)
            .first() {
            return wallet
        } else {
            let wallet = Wallet(userId: userId)
            try await wallet.save(on: database)
            return wallet
        }
    }
}
