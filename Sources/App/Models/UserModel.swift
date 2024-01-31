import Foundation
import Fluent
import Vapor

final class UserModel: Model {
    static var schema: String = SchemaEnum.users.rawValue

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: FieldKeys.name)
    var name: String?

    @OptionalField(key: FieldKeys.lastname)
    var lastname: String?

    @OptionalField(key: FieldKeys.username)
    var username: String?

    @Field(key: FieldKeys.email)
    var email: String

    @Field(key: FieldKeys.password)
    var password: String

    @OptionalField(key: FieldKeys.city)
    var city: String?

    @OptionalField(key: FieldKeys.postalcode)
    var postalcode: String?

    @OptionalField(key: FieldKeys.address)
    var address: String?

    @OptionalField(key: FieldKeys.country)
    var country: String?

    @Field(key: FieldKeys.role)
    var role: RoleEnum.RawValue

    @OptionalField(key: FieldKeys.subscriptionIsActive)
    var subscriptionIsActive: Date?

    @OptionalField(key: FieldKeys.myCourses)
    var myCourses: [UUID]?

    @OptionalField(key: FieldKeys.bio)
    var bio: String?

    @OptionalField(key: FieldKeys.completedCourses)
    var completedCourses: [UUID]?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    @OptionalField(key: FieldKeys.userImage)
    var userImage: URL?

    init() {}

    init(username: String?, email: String, password: String, role: RoleEnum.RawValue, 
        createdAt: Date?, updatedAt: Date?) {
        self.username = username
        self.email = email
        self.password = password
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(name: String?, lastname: String?, username: String?, email: String, password: String,
        city: String?, postalcode: String?, address: String?, country: String?, bio: String?, 
        createdAt: Date?, updatedAt: Date?) {
        self.name = name
        self.lastname = lastname
        self.username = username
        self.email = email
        self.password = password
        self.city = city
        self.postalcode = postalcode
        self.address = address
        self.country = country
        self.bio = bio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(subscriptionIsActive: Date?) {
        self.subscriptionIsActive = subscriptionIsActive
    }

    init(myCourses: [UUID]?) {
        self.myCourses = myCourses
    }

    init(completedCourses: [UUID]?) {
        self.completedCourses = completedCourses
    }

    init(userImage: URL?) {
        self.userImage = userImage
    }

    init(role: RoleEnum.RawValue) {
        self.role = role
    }

    final class Public: Content {
        var id: UUID?
        var name: String?
        var lastname: String?
        var username: String?
        var email: String
        var password: String
        var city: String?
        var subscriptionIsActive: Date?
        var myCourses: [UUID]?
        var completedCourses: [UUID]?
        var bio: String?
        var createdAt: Date?
        var updatedAt: Date?

        init(id: UUID? = nil, name: String? = nil, lastname: String? = nil, username: String? = nil, email: String, password: String,
            city: String? = nil, subscriptionIsActive: Date? = nil, myCourses: [UUID]? = nil, completedCourses: [UUID]? = nil, bio: String? = nil,
            createdAt: Date? = nil, updatedAt: Date? = nil) {
            self.id = id
            self.name = name
            self.lastname = lastname
            self.username = username
            self.email = email
            self.password = password
            self.city = city
            self.subscriptionIsActive = subscriptionIsActive
            self.myCourses = myCourses
            self.completedCourses = completedCourses
            self.bio = bio
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

extension UserModel: Content {}

extension UserModel {
    func convertToPublic() -> UserModel.Public {
        return UserModel.Public(name: name, lastname: lastname, username: username, email: email, password: password,
        city: city, subscriptionIsActive: subscriptionIsActive, myCourses: myCourses, completedCourses: completedCourses, bio: bio)
    }
    
}

extension Collection where Element: UserModel {
    func convertToPublic() -> [UserModel.Public] {
        return self.map {
            $0.convertToPublic()
        }
    }
}

extension UserModel: Authenticatable {}
extension UserModel: ModelAuthenticatable {
    static var usernameKey = \UserModel.$email
    static var passwordHashKey = \UserModel.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension UserModel: ModelSessionAuthenticatable {}
extension UserModel: ModelCredentialsAuthenticatable {}