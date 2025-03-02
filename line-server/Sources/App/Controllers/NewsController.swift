import Fluent
import Vapor

struct NewsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let news = routes.grouped("api", "news")
        news.get(use: index)
        news.get("categories", use: categories)
        news.get(":newsId", use: show)
        news.get("category", ":category", use: byCategory)
    }
    
    // ニュース一覧取得
    @Sendable
    func index(req: Request) async throws -> NewsListResponse {
        // ページネーション用のパラメータ
        let limit = req.query[Int.self, at: "limit"] ?? 20
        let page = req.query[Int.self, at: "page"] ?? 1
        
        // プロモートされたニュースを優先的に取得
        let promotedNews = try await News.query(on: req.db)
            .filter(\.$isPromoted == true)
            .sort(\.$publishedAt, .descending)
            .limit(5)
            .all()
        
        // 通常のニュース記事を取得
        let regularNews = try await News.query(on: req.db)
            .filter(\.$isPromoted == false)
            .sort(\.$publishedAt, .descending)
            .paginate(PageRequest(page: page, per: limit))
            .items
        
        // プロモートされたニュースと通常のニュースを結合
        let allNews = promotedNews + regularNews
        
        // DTOに変換
        let newsDTOs = allNews.map { NewsDTO(news: $0) }
        
        return NewsListResponse(news: newsDTOs)
    }
    
    // ニュースカテゴリー一覧取得
    @Sendable
    func categories(req: Request) async throws -> NewsCategoryResponse {
        return NewsCategoryResponse()
    }
    
    // 特定のニュース記事取得
    @Sendable
    func show(req: Request) async throws -> NewsDTO {
        guard let newsId = req.parameters.get("newsId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "無効なニュースIDです")
        }
        
        guard let news = try await News.find(newsId, on: req.db) else {
            throw Abort(.notFound, reason: "ニュース記事が見つかりません")
        }
        
        return NewsDTO(news: news)
    }
    
    // カテゴリー別ニュース一覧取得
    @Sendable
    func byCategory(req: Request) async throws -> NewsListResponse {
        let categoryString = req.parameters.get("category")!
        
        // カテゴリーのバリデーション
        guard let category = NewsCategory(rawValue: categoryString) else {
            throw Abort(.badRequest, reason: "無効なニュースカテゴリーです")
        }
        
        // ページネーション用のパラメータ
        let limit = req.query[Int.self, at: "limit"] ?? 20
        let page = req.query[Int.self, at: "page"] ?? 1
        
        // 指定されたカテゴリーのニュースを取得
        let news = try await News.query(on: req.db)
            .filter(\.$category == category)
            .sort(\.$publishedAt, .descending)
            .paginate(PageRequest(page: page, per: limit))
            .items
        
        // DTOに変換
        let newsDTOs = news.map { NewsDTO(news: $0) }
        
        return NewsListResponse(news: newsDTOs)
    }
}
