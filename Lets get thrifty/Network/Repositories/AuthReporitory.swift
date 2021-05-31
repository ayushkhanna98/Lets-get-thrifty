//
//  AuthReporitory.swift
//  Lets get thrifty
//
//  Created by AYUSH on 17/05/21.
//

import Foundation

struct AuthRepository {
    
    private init() {
        // singleton
    }
    
    static let shared = AuthRepository()
    
    func login(with manager: WebServiceManagerInterface,email: String, password: String, callback: @escaping ((LoginToken?, ResponseError?)->())) {
        
        let parameters = ["email": email, "password": password]
        let request = Request(api: APIClient.login, method: .post)
        request.parameters = parameters
        let requestBlock = RequestBlock<LoginToken>(request: request, callback: callback)
        manager.dispatch(block: requestBlock)
        
    }
    
    func getUser(with manager: WebServiceManagerInterface, token: LoginToken, callback: @escaping (UserModel?, ResponseError?)->()) {
        
        let headers = ["authorization": "Bearer \(token.token)"]
        let request = Request(api: APIClient.getUser, method: .get)
        request.headers = headers
        let requestBlock = RequestBlock<UserModel>(request: request, callback: callback)
        manager.dispatch(block: requestBlock)
    }
}
