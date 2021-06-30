//
//  SellYourListingTableViewHeader.swift
//  Lets get thrifty
//
//  Created by AYUSH on 24/05/21.
//

import UIKit

class SellYourListingTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet private weak var _backgroundView: UIView!
    
    var userDidTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(_userDidTap))
        self.addGestureRecognizer(gestureRec)
        
    }
    
     @objc private func _userDidTap() {
        userDidTap?()
    }
    
}
