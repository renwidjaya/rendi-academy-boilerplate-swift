import Foundation
import Fluent
import Vapor

struct UserController: UserHandlerProtocol {
    typealias answer = UserModel.Public
    typealias request = Request
    typealias status = HTTPStatus

    func create(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user = try req.content.decode(CreateUserDTO.self)
        return try await UserService.create(req, user)
    }

    func get(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user = try req.auth.require(UserModel.self)

        print(user)
        return try await UserService.get(req, object: user.id!.uuidString)
    }
    
    func update(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user = try req.auth.require(UserModel.self)
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        return try await UserService.update(req, object: user.id!.uuidString, updateDTO: updatedUser)
    }
    
    func delete(_ req: Vapor.Request) async throws -> HTTPStatus {
        let user = try req.auth.require(UserModel.self)
        return try await UserService.delete(req, object: user.id!.uuidString)
    }
}