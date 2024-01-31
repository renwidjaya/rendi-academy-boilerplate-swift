import Foundation
import Vapor

struct CheckAdminMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(UserModel.self), user.role == RoleEnum.admin.rawValue else {
            throw Abort(.forbidden, reason: "Sorry, you need admin rights to access this resource. Please contact an sysadmin if you think this is incorrect")
        }

        return try await next.respond(to: request)
    }
}

