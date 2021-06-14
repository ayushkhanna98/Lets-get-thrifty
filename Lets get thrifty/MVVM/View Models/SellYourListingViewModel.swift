//
//  SellYourListingViewModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 24/05/21.
//

import Foundation
import RxRelay

class SellYourListingViewModel: BaseViewModel {
    let listings = BehaviorRelay<[Listing]>(value: [])
    
    override func loaded() {
        fetchMyListings()
    }
    
    func fetchMyListings() {
        self.isLoading.accept(true)
        LisingsRepository.shared.getMyListings(with: self.webserviceManager) { [weak self] response, error in
            self?.isLoading.accept(false)
            if let e = error {
                self?.generalErrors.accept(e)
                return
            }
            guard let l = response?.data else {
                self?.generalErrors.accept(ResponseError(statusCode: nil,
                                                         name: nil,
                                                         message: "Something went horribly wrong!"))
                return
            }
            self?.listings.accept(l)
        }
    }
}
