//
//  ListingModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 02/06/21.
//

import UIKit

struct ListingWebModel {
    let price: Int
    let name: String
    let description: String
    let condition: Int
    let address: String
    let email: String
    let phone: String
    let photos: [UIImage]
    
    
    init(listingDetails: ListingDetailsModel, listingContact: ListingContactModel) {
        price = listingDetails.price
        name = listingDetails.name
        description = listingDetails.description
        photos = listingDetails.images
        condition = listingDetails.condition
        address = listingContact.address
        email = listingContact.email
        phone = listingContact.phone
    }
}

struct ListingPicturesResponse: Codable {
    var photos: [String]?
}
