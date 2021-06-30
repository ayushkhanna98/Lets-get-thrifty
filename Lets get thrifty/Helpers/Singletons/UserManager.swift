//
//  UserManager.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation


class UserManager {
    
    private static let userKey = "USERDEFAULTS.USER"
    private static let loginTokenKey = "USERDEFAULTS.LOGN_TOKEN"
    
    private init() {
        try? _loadLocalData()
    }
    
    static let shared = UserManager()
    
    var loginToken: LoginToken?
    var user: UserModel?
    
    var userName: String? {
        user?.name
    }
    
    var isLoggedIn : Bool {
        return UserDefaults.standard.object(forKey: UserManager.loginTokenKey) != nil
    }
    
    func saveLocally() throws {
       try UserDefaults.standard.setObject(user, forKey: UserManager.userKey)
       try UserDefaults.standard.setObject(loginToken, forKey: UserManager.loginTokenKey)
    }
    
    func logOutUser() {
        LocalStorageManager.shared.resetAllUserRelatedData()
    }
    
    private func _loadLocalData() throws {
       try self.user = UserDefaults.standard.getObject(forKey: UserManager.userKey, castTo: UserModel.self)
       try self.loginToken = UserDefaults.standard.getObject(forKey: UserManager.loginTokenKey, castTo: LoginToken.self)
    }
    
}
