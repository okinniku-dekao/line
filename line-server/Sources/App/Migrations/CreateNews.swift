import Fluent

struct CreateNews: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(News.schema)
            .id()
            .field(News.FieldKeys.title, .string, .required)
            .field(News.FieldKeys.content, .string, .required)
            .field(News.FieldKeys.imageUrl, .string)
            .field(News.FieldKeys.url, .string, .required)
            .field(News.FieldKeys.category, .string, .required)
            .field(News.FieldKeys.publisher, .string, .required)
            .field(News.FieldKeys.isPromoted, .bool, .required)
            .field(News.FieldKeys.publishedAt, .datetime)
            .field(News.FieldKeys.createdAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        return database.schema(News.schema).delete()
    }
}
