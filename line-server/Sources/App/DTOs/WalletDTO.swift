import Vapor

struct WalletDTO: Content {
    let id: UUID
    let balance: Double
    let points: Int
    let status: String
    
    init(wallet: Wallet) {
        self.id = wallet.id!
        self.balance = wallet.balance
        self.points = wallet.points
        self.status = wallet.status.rawValue
    }
}

struct TransactionDTO: Content {
    let id: UUID
    let amount: Double
    let type: String
    let status: String
    let description: String?
    let merchantName: String?
    let reference: String?
    let createdAt: Date?
    
    init(transaction: Transaction) {
        self.id = transaction.id!
        self.amount = transaction.amount
        self.type = transaction.type.rawValue
        self.status = transaction.status.rawValue
        self.description = transaction.description
        self.merchantName = transaction.merchantName
        self.reference = transaction.reference
        self.createdAt = transaction.createdAt
    }
}

struct TransactionListResponse: Content {
    let transactions: [TransactionDTO]
    let count: Int
    
    init(transactions: [TransactionDTO]) {
        self.transactions = transactions
        self.count = transactions.count
    }
}

struct CreateTransactionRequest: Content {
    let amount: Double
    let type: String
    let description: String?
    let merchantName: String?
    let reference: String?
}

struct TopUpRequest: Content {
    let amount: Double
    let paymentMethod: String
}

struct TransferRequest: Content {
    let recipientId: UUID
    let amount: Double
    let description: String?
}

struct PaymentRequest: Content {
    let merchantName: String
    let amount: Double
    let reference: String?
}
