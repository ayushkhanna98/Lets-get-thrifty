//
//  LoginSignupViewModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation
import RxCocoa

class LoginSignupViewModel: BaseViewModel {
    
    let didLoginSuccessfully = PublishRelay<Bool>()
    let didSignUpSuccessfully = PublishRelay<Bool>()
    
    func login(email: String, password: String) {
        self.isLoading.accept(true)
        AuthRepository.shared.login(with: webserviceManager, email: email, password: password ) {  [weak self] (loginToken, err) in
            if let e = err {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(e)
                return
            }
            guard let token = loginToken else {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(ResponseError(statusCode: nil, name: "Something Went wrong", message: "Please try again"))
                return
            }
            self?._getUser(token: token)
        }
    }
    
    func _getUser(token: LoginToken) {
        AuthRepository.shared.getUser(with: webserviceManager, token: token) { [weak self](user, err) in
            if let e = err {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(e)
                return
            }
            guard let user = user else {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(ResponseError(statusCode: nil, name: "Something Went wrong", message: "Please try again"))
                return
            }
            
            UserManager.shared.user = user
            UserManager.shared.loginToken = token
            do {
               try UserManager.shared.saveLocally()
            } catch {
                self?.generalErrors.accept(ResponseError(statusCode: nil, name: "Something Went wrong", message: "Please try again"))
                self?.isLoading.accept(false)
                return
            }
            self?.didLoginSuccessfully.accept(true)
            self?.isLoading.accept(false)
            
        }
    }
    
    func signUp() {
        // to-do
    }
    
    
    
    
    //MARK: - Validations
    //Validations return error for text field
    func validateName(name: String) -> String? {
        return name.count > 4 ? nil : "Please enter a valid name"
    }
    
    func validateEmail(email: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email) ? nil : "Please enter a valid email"
    }
    
    func validatePhone(phone: String) -> String? {
        return phone.count > 6 ? nil : "Please enter a valid phone"
    }
    
    func validatePassword(password: String) -> String? {
        return password.count > 6 ? nil : "Please enter an longer password"
    }
}
