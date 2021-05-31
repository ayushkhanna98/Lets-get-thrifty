//
//  RootControllerManager.swift
//  Lets get thrifty
//
//  Created by AYUSH on 18/05/21.
//

import UIKit

struct RootControllerManager {
    
    static let shared = RootControllerManager()
    
    private init() {
        //singleton
    }
    
    func setRootViewController() {
        
        if UserManager.shared.isLoggedIn {
            let tabBar = UIStoryboard.init(name: "TabBarStoryboard", bundle: nil)
            let vc = tabBar.instantiateViewController(identifier: "TabBarController") as! UITabBarController
            
            UIApplication.shared.windows.first!.rootViewController = vc
        } else {
            
        }
    }
}
