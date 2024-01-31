import Foundation
import Fluent
import Vapor

protocol TransformProtocol {
    associatedtype answerWithID

    func getIDFromSlug(_ req: Request, slug: String) async throws -> answerWithID
}