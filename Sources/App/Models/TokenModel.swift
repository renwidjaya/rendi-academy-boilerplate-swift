import Foundation
import Fluent
import Vapor
import Crypto

final class TokenModel: Model {
    static var schema: String = SchemaEnum.tokens.rawValue

    @ID
    var id: UUID?

    @Field(key: FieldKeys.token)
    var token: String

    @Parent(key: FieldKeys.userID)
    var userID: UserModel

    init() {}

    init(id: UUID?, token: String, userID: UserModel.IDValue) {
        self.id = id
        self.token = token
        self.$userID.id = userID
    }
}

extension TokenModel: Content {}

extension TokenModel: ModelTokenAuthenticatable {
    typealias User = App.UserModel  // Use the correct type here
    static var valueKey = \TokenModel.$token
    static var userKey = \TokenModel.$userID

    var isValid: Bool {
        true
    }
}

extension TokenModel {
    static func generate(for user: UserModel) throws -> TokenModel {
        let random = [UInt8].random(count: 16).base64
        return try TokenModel(id: nil, token: random, userID: user.requireID())
    }
}
