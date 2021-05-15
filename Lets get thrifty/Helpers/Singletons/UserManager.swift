//
//  UserManager.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation


class UserManager {
    
    private init() {
        // private constructor
    }
    
    static let shared = UserManager()
    
    var loginToken: String?
}
