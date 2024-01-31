import Foundation
import Fluent
import Vapor

extension TokenModel {
    struct FieldKeys {
        static var token: FieldKey {"token"}
        static var userID: FieldKey {"userID"}
    }
}