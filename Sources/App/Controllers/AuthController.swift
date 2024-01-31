import Foundation
import Fluent
import Vapor

struct AuthController: AuthProtocol {
    func loginHandler(_ req: Request) throws -> EventLoopFuture<TokenModel> {
        let user = try req.auth.require(UserModel.self)
        let token = try TokenModel.generate(for: user)

        print("Authenticated user:", user)
        print("Generated token:", token)

        return token.save(on: req.db).map { token }
    }
}