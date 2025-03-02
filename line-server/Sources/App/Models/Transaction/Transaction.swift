import Fluent
import Vapor

final class Transaction: Model, Content, @unchecked Sendable {
    static let schema = "transactions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.walletId)
    var wallet: Wallet
    
    @Field(key: FieldKeys.amount)
    var amount: Double
    
    @Field(key: FieldKeys.type)
    var type: TransactionType
    
    @Field(key: FieldKeys.status)
    var status: TransactionStatus
    
    @Field(key: FieldKeys.description)
    var description: String?
    
    @Field(key: FieldKeys.merchantName)
    var merchantName: String?
    
    @Field(key: FieldKeys.reference)
    var reference: String?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, walletId: UUID, amount: Double, type: TransactionType, status: TransactionStatus = .completed, description: String? = nil, merchantName: String? = nil, reference: String? = nil) {
        self.id = id
        self.$wallet.id = walletId
        self.amount = amount
        self.type = type
        self.status = status
        self.description = description
        self.merchantName = merchantName
        self.reference = reference
    }
}

enum TransactionType: String, Codable {
    case deposit
    case withdrawal
    case payment
    case transfer
    case refund
    case pointsEarned
    case pointsRedeemed
}

enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
    case cancelled
    case refunded
}

// MARK: - Field Keys
extension Transaction {
    enum FieldKeys {
        static let walletId: FieldKey = "wallet_id"
        static let amount: FieldKey = "amount"
        static let type: FieldKey = "type"
        static let status: FieldKey = "status"
        static let description: FieldKey = "description"
        static let merchantName: FieldKey = "merchant_name"
        static let reference: FieldKey = "reference"
        static let createdAt: FieldKey = "created_at"
    }
}
