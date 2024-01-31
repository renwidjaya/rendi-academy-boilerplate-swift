import Foundation
import Fluent
import Vapor

protocol AuthProtocol {
    func loginHandler(_ req: Request) throws -> EventLoopFuture<TokenModel>
}