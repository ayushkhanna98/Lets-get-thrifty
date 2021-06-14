//
//  AddYourAddressViewModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 01/06/21.
//

import UIKit
import RxRelay

class AddYourAddressViewModel: BaseViewModel {
    var listingDetails: ListingDetailsModel!
    var selectedCountryCode: String = "+971"
    var listing: Listing?
    let didUpload = BehaviorRelay<Listing?>(value: nil)
    
    
    convenience init(webserviceManager: WebServiceManagerInterface = WebServiceManager(), listingDetailsModel: ListingDetailsModel) {
        self.init(webServiceMangerInterface: webserviceManager)
        self.listingDetails = listingDetailsModel
    }
    
    func checkEmailValidity(email: String) -> String? {
        
        NSPredicate(format:"SELF MATCHES %@", Constants.emailRegex).evaluate(with: email) ? nil : "Please enter a valid email"
    }
    
    func postListing(contact: ListingContactModel) {
        self.isLoading.accept(true)
        let listing = ListingWebModel(listingDetails: listingDetails, listingContact: contact)
        LisingsRepository.shared.postListing(with: self.webserviceManager, listingModel: listing) { [weak self] listing, error in
            if let e = error {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(e)
                return
            }
            guard let id = listing?._id else {
                self?.isLoading.accept(false)
                self?.generalErrors.accept(ResponseError(statusCode: nil, name: nil, message: "Something went wrong"))
                return
            }
            self?.listing = listing
            self?.postPictures(id: id)
        }
    }
    
    
    func postPictures(id: String) {
        self.isLoading.accept(true)
        LisingsRepository.shared.postLingingPictures(with: self.webserviceManager,
                                                     listingiD: id,
                                                     photos: listingDetails.images)
        { [weak self] photos, error in
            self?.isLoading.accept(false)
            if let e = error {
                self?.generalErrors.accept(e)
                return
            }
            guard let p = photos?.photos, let listing = self?.listing else {
                self?.generalErrors.accept(ResponseError(statusCode: nil, name: nil, message: "Something went wrong"))
                return
            }
            
            self?.listing?.photos = p
            self?.didUpload.accept(listing)
            
            
            
        }
    }
}
