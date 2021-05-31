//
//  YourListingsTableViewCell.swift
//  Lets get thrifty
//
//  Created by AYUSH on 25/05/21.
//

import UIKit

class YourListingsTableViewCell: UITableViewCell {

    @IBOutlet private weak var _imageView: UIImageView!
    @IBOutlet private weak var _nameLabel: UILabel!
    @IBOutlet private weak var _description: UILabel!
    @IBOutlet private weak var _price: UILabel!
    
    func apply() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
