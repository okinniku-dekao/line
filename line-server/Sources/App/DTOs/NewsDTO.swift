import Vapor

struct NewsDTO: Content {
    let id: UUID
    let title: String
    let content: String
    let imageUrl: String?
    let url: String
    let category: String
    let publisher: String
    let isPromoted: Bool
    let publishedAt: Date?
    
    init(news: News) {
        self.id = news.id!
        self.title = news.title
        self.content = news.content
        self.imageUrl = news.imageUrl
        self.url = news.url
        self.category = news.category.rawValue
        self.publisher = news.publisher
        self.isPromoted = news.isPromoted
        self.publishedAt = news.publishedAt
    }
}

struct NewsListResponse: Content {
    let news: [NewsDTO]
    let count: Int
    
    init(news: [NewsDTO]) {
        self.news = news
        self.count = news.count
    }
}

struct NewsCategoryResponse: Content {
    let categories: [String]
    
    init() {
        self.categories = NewsCategory.allCases.map { $0.rawValue }
    }
}
