//
//  ListingDetailsModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 01/06/21.
//

import UIKit

struct ListingDetailsModel {
    let price: Int
    let name: String
    let description: String
    let condition: Int
    let images: [UIImage]
}

struct ListingContactModel {
    let address: String
    let email: String
    let phone: String
    
    init(street: String, city: String, state: String, country: String, email: String, phone: String) {
        self.address = "\(street) \(city) \(state) \(country)"
        self.email = email
        self.phone = phone
    }
}
