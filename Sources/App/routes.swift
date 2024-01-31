import Fluent
import Vapor

func routes(_ app: Application) throws {
   
    // Basic Auth Middleware
    let basicAuthMiddleware = UserModel.authenticator()
    let guardMiddleware = UserModel.guardMiddleware()
    let basicAuthGroup = app.routes.grouped(basicAuthMiddleware, guardMiddleware)

    // Token Auth
    let tokenAuthMiddleware = TokenModel.authenticator()
    let tokenAuthGroup = app.routes.grouped(tokenAuthMiddleware, guardMiddleware)

    // Admin Auth
    let adminMiddleware = CheckAdminMiddleware()
    let adminTokenAuthGroup = app.routes.grouped(tokenAuthMiddleware, adminMiddleware)

    // MARK: Controller 
    let authController = AuthController()
    let userController = UserController()

    // MARK: Auth Registered Routes
    basicAuthGroup.post("login", use: authController.loginHandler)

    // MARK: User Registered Routes
    basicAuthGroup.post("users", "register", use: userController.create)
    tokenAuthGroup.get("users", "profile", use: userController.get)
    tokenAuthGroup.patch("users", "profile", "update", use: userController.update)
    tokenAuthGroup.delete("users", "profile", "delete", use: userController.delete)

}
