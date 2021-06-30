//
//  MapAnnotation.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 17/06/2021.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, info: String) {
        self.coordinate = coordinate
        self.info = info
        self.title = title
    }
    
    
}
