import Fluent
import Vapor

final class News: Model, Content, @unchecked Sendable {
    static let schema = "news"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.title)
    var title: String
    
    @Field(key: FieldKeys.content)
    var content: String
    
    @Field(key: FieldKeys.imageUrl)
    var imageUrl: String?
    
    @Field(key: FieldKeys.url)
    var url: String
    
    @Field(key: FieldKeys.category)
    var category: NewsCategory
    
    @Field(key: FieldKeys.publisher)
    var publisher: String
    
    @Field(key: FieldKeys.isPromoted)
    var isPromoted: Bool
    
    @Timestamp(key: FieldKeys.publishedAt, on: .none)
    var publishedAt: Date?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, title: String, content: String, imageUrl: String? = nil, url: String, category: NewsCategory, publisher: String, isPromoted: Bool = false, publishedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.imageUrl = imageUrl
        self.url = url
        self.category = category
        self.publisher = publisher
        self.isPromoted = isPromoted
        self.publishedAt = publishedAt
    }
}

enum NewsCategory: String, Codable, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case health
    case science
}

// MARK: - Field Keys
extension News {
    enum FieldKeys {
        static let title: FieldKey = "title"
        static let content: FieldKey = "content"
        static let imageUrl: FieldKey = "image_url"
        static let url: FieldKey = "url"
        static let category: FieldKey = "category"
        static let publisher: FieldKey = "publisher"
        static let isPromoted: FieldKey = "is_promoted"
        static let publishedAt: FieldKey = "published_at"
        static let createdAt: FieldKey = "created_at"
    }
}
