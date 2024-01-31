import Foundation
import Fluent
import Vapor

protocol ContentFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status

    func search(_ req: request, term: String) async throws -> [model]
}

protocol BackendContentFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    func getByStatus(_ req: request, status: StatusEnum.RawValue) async throws -> [model]
    func getAllWithStatus(_ req: request) async throws -> [model]
    func search(_ req: request, term: String) async throws -> [model]
}

protocol SearchUserProtocol {
    associatedtype request
    func search(_ req: Request, term: String) async throws -> [UserModel.Public] 
}