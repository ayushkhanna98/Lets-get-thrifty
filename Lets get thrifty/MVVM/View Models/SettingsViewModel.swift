//
//  SettingsViewModel.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 28/06/2021.
//

import Foundation


class SettingsViewModel: BaseViewModel {
    
    func logoutUser() {
        UserManager.shared.logOutUser()
        RootControllerManager.shared.setRootViewController()
        
    }
    
}
