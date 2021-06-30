//
//  ImageCollectionViewCell.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 29/06/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    weak var _imageView: UIImageView!
    
    func apply(imageUrl: String) {
        _imageView.sd_setImage(with: URL(string: APIClient.listingsPhoto(url: imageUrl), relativeTo: nil))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let i = UIImageView(frame: self.bounds)
        _imageView = i
        _imageView.contentMode = .scaleAspectFit
        addSubview(i)
        //_imageView.heroID = "x"
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
