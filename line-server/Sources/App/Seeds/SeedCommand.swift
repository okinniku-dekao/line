import Vapor

struct SeedCommand: Command {
    struct Signature: CommandSignature {}
    
    var help: String {
        "テストデータをデータベースに投入します"
    }
    
    func run(using context: CommandContext, signature: Signature) throws {
        let app = context.application
        app.logger.info("シードデータを投入中です...")
        
        do {
            try app.eventLoopGroup.next().makeFutureWithTask {
                try await SeedController.seed(app)
            }.wait()
            app.logger.info("シードデータの投入が完了しました")
        } catch {
            app.logger.error("シードデータの投入に失敗しました: \(error)")
            throw error
        }
    }
}
