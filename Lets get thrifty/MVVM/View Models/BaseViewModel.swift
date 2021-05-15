//
//  BaseViewModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation
import RxCocoa
import RxSwift

class BaseViewModel {
    private(set) var webserviceManager: WebServiceManagerInterface
    private(set) var isLoading = BehaviorRelay(value: false)
    private(set) var generalErrors = BehaviorRelay<ResponseError?>(value: nil)
    private(set) var disposableBag = DisposeBag()

    var maximumCommentCharacterAllowed = 160

    required init( webServiceMangerInterface: WebServiceManagerInterface = WebServiceManager() ) {
        self.webserviceManager = webServiceMangerInterface
    }
    func throwNoInternetErrorIfCan() -> Bool {
        let isInternetAvailable = Helper.isInternetAvailable()
        if !isInternetAvailable {
            self.generalErrors.accept(ResponseError(statusCode: nil, name: "No internet connection" , message: "Please connect to the internet!"))
        }
        return !isInternetAvailable
    }
    
    func loaded() {
        // abstract method
    }
}
