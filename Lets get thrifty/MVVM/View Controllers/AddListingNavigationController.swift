//
//  AddListingNavigationController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 07/06/21.
//

import UIKit

class AddListingNavigationController: UINavigationController {
    
     var listingDelegate: ListingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AddListingNavigationController {
    struct Builder {
        static func build(deletage: ListingDelegate?) -> AddListingNavigationController  {
            let storyBoard = UIStoryboard.init(name: "Sell", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: AddListingNavigationController.identifier) as! AddListingNavigationController
            if let del = deletage {
                vc.listingDelegate = del
            }
            return vc
        }
    }
}

protocol ListingDelegate {
    func didAddNewListing(listing: Listing)
}
