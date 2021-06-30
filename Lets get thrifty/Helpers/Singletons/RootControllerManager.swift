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
            let storyBoard = UIStoryboard.init(name: "TabBarStoryboard", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
            
            UIApplication.shared.windows.first!.rootViewController = vc
        } else {
            let storyBoard = UIStoryboard.init(name: "LoginOrSignUp", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "LoginSignupViewController")
            UIApplication.shared.windows.first!.rootViewController = vc
        }
    }
}
