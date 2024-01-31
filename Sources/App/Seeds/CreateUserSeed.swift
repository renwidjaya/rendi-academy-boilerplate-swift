import Foundation
import Fluent
import Vapor

struct CrateUserSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        let admin = [
            UserModel(username: "admin", email: "admin@gmail.com", password: try Bcrypt.hash("@Admin2023"), role: RoleEnum.admin.rawValue, createdAt: Date(), updatedAt: Date()),
            UserModel(username: "Rendi Widjaya", email: "renwidjaya@gmail.com", password: try Bcrypt.hash("@Admin2023"), role: RoleEnum.admin.rawValue, createdAt: Date(), updatedAt: Date())
        ]

        try await admin.create(on: database)
    }

    func revert(on database: Database) async throws {
        try await UserModel.query(on: database).delete()
    }
}