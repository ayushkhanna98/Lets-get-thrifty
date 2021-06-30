//
//  LocalStorageManager.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 29/06/2021.
//

import Foundation

struct LocalStorageManager {
    
    private init() {
        // singleton
    }
    
    static let shared = LocalStorageManager()
    
    let userDefaults = UserDefaults.standard
    
    func resetAllUserRelatedData() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }
}
