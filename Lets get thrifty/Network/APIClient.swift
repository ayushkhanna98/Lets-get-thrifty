//
//  Network.swift
//  Lets get thrifty
//
//  Created by AYUSH on 16/05/21.
//

import Foundation

struct APIClient {
    private static let baseURL = "http://192.168.1.169:5000"
    private static let apiVersion = "v1"
    private static let apiEndpoint = baseURL + "/api/" + apiVersion
    private static let imagesURL = baseURL + "/uploads"
    
    // MARK: - Auth APIs
    
    private static var authApi: String {
        apiEndpoint + "/auth"
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
        apiEndpoint + "/listings"
    }
    
    static func listingsPhotos(listingId: String) -> String {
        return (listings + "/" + listingId + "/" + "photo")
    }
    
    static func listingsPhoto(url: String) -> String {
        return imagesURL + "/" + url
    }
}
