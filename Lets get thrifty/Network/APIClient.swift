//
//  Network.swift
//  Lets get thrifty
//
//  Created by AYUSH on 16/05/21.
//

import Foundation

struct APIClient {
    private static let apiURL = "http://localhost:5000/api/"
    private static let apiVersion = "v1"
    private static let baseURL = apiURL + apiVersion
    
    // MARK: - Auth APIs
    
    private static var authApi: String {
        baseURL + "/auth"
    }
    
    static var register :String {
        authApi + "/register"
    }
    
    static var login: String {
        authApi + "/login"
    }
    
    static var getUser: String {
        authApi + "/me"
    }
    
    //MARK: - Listings APIs
    
    static var listings : String {
        baseURL + "/listings"
    }
    
    static func listingsPhotos(listingId: String) -> String {
        return (listings + "/" + listingId + "/" + "photo")
    }
}
