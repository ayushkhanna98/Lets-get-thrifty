//
//  Helper.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation
import Reachability

struct Helper {
    static func isInternetAvailable() -> Bool {
        let reachability = Reachability()
        return reachability?.connection != Optional.none
    }
}
