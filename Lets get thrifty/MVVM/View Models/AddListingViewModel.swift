//
//  AddListingViewModel.swift
//  Lets get thrifty
//
//  Created by AYUSH on 25/05/21.
//

import Foundation


class AddListingViewModel: BaseViewModel {
    enum ImageState {
        case HasImage
        case NoImage
    }
    
    var imageStates: [ImageState] = [.NoImage,.NoImage, .NoImage, .NoImage , .NoImage, .NoImage]
    
    
}
