import Fluent
import Vapor

final class Wallet: Model, Content, @unchecked Sendable {
    static let schema = "wallets"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.userId)
    var user: User
    
    @Field(key: FieldKeys.balance)
    var balance: Double
    
    @Field(key: FieldKeys.points)
    var points: Int
    
    @Field(key: FieldKeys.status)
    var status: WalletStatus
    
    @Children(for: \.$wallet)
    var transactions: [Transaction]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, balance: Double = 0, points: Int = 0, status: WalletStatus = .active) {
        self.id = id
        self.$user.id = userId
        self.balance = balance
        self.points = points
        self.status = status
    }
}

enum WalletStatus: String, Codable {
    case active
    case suspended
    case closed
}

// MARK: - Field Keys
extension Wallet {
    enum FieldKeys {
        static let userId: FieldKey = "user_id"
        static let balance: FieldKey = "balance"
        static let points: FieldKey = "points"
        static let status: FieldKey = "status"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
