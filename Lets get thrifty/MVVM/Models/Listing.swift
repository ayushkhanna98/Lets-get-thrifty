//
//  Listing.swift
//  Lets get thrifty
//
//  Created by AYUSH on 03/06/21.
//

import Foundation

struct Listing: Codable {
    let _id: String?
    let price: Int?
    let name: String?
    let description: String?
    let condition: Int?
    let address: String?
    let email: String?
    let phone: String?
    var photos: [String]?
    var status: Int? = nil
    let location: Location?
    
    var listingPrice: String {
        "AED" + "\(self.price ?? 0)"
    }
    

}

struct Location: Codable {
    let street: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: String?
    let coordinates: [Double]?
}
