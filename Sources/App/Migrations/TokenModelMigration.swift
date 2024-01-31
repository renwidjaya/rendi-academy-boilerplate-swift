import Foundation
import Fluent
import Vapor

struct TokenModelMigration: AsyncMigration {
    let keys = TokenModel.FieldKeys.self
    let schema = TokenModel.schema.self

    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.token, .string)
            .field(keys.userID, .uuid)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
    
}