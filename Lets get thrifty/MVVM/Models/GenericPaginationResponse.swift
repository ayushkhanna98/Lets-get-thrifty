//
//  File.swift
//  Lets get thrifty
//
//  Created by AYUSH on 07/06/21.
//

import Foundation

struct GenericPaginationResponse<T:Codable>: Codable {
    
    let data: T?
    let count: Int
}
