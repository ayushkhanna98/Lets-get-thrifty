//
//  ListingViewModel.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 15/06/2021.
//

import Foundation

class ListingViewModel : BaseViewModel {
    var listing: Listing?
    var didInitializeCollectionView = false
    var initialCollectionViewIndex: Int?
    
    convenience init(webserviceManager: WebServiceManagerInterface, listing: Listing, initialCollectionViewIndex: Int? = nil) {
        self.init(webServiceMangerInterface: webserviceManager)
        self.listing = listing
        self.initialCollectionViewIndex = initialCollectionViewIndex
    }
}
