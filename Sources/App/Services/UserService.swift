import Foundation
import Fluent
import Vapor

struct UserService: UserProtocol {
    typealias model = UserModel

    typealias answer = UserModel.Public

    typealias request = Request

    typealias createDTO = CreateUserDTO

    typealias updateDTO = UpdateUserDTO

    typealias status = HTTPStatus
    

    static func create(_ req: Vapor.Request, _ createDTO: CreateUserDTO) async throws -> UserModel.Public {
        let user = UserModel(username: createDTO.username,
                            email: createDTO.email,
                            password: try Bcrypt.hash(createDTO.password),
                            role: RoleEnum.registered.rawValue,
                            createdAt: Date(),
                            updatedAt: Date())

        try await user.save(on: req.db)
        return user.convertToPublic()
    }

    static func get(_ req: Vapor.Request, object: String) async throws -> UserModel.Public {
        let uuid = UUID(uuidString: object)

        guard let user = try await UserModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: uuid)) cloud not be found")
        }

        return user.convertToPublic()
    }

    static func update(_ req: Vapor.Request, object: String, updateDTO: UpdateUserDTO) async throws -> UserModel.Public {
        let uuid = UUID(uuidString: object)

        guard let user = try await UserModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: uuid)) cloud not be found")
        }

        user.name = updateDTO.name ?? user.name
        user.lastname = updateDTO.lastname ?? user.lastname
        user.username = updateDTO.username ?? user.username
        user.email = updateDTO.email ?? user.email
        user.city = updateDTO.city ?? user.city
        user.address = updateDTO.address ?? user.address
        user.country = updateDTO.country ?? user.country
        user.postalcode = updateDTO.postalcode ?? user.postalcode

        try await user.save(on: req.db)
        return user.convertToPublic()

    }

    static func delete(_ req: Vapor.Request, object: String) async throws -> Vapor.HTTPStatus {
        let uuid = UUID(uuidString: object)

        guard let user = try await UserModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "The user with ID of \(String(describing: uuid)) cloud not be found")
        }

        try await user.delete(on: req.db)
        return .ok
    }
}