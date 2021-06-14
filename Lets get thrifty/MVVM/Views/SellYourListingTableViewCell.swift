//
//  SellYourListingTableViewCell.swift
//  Lets get thrifty
//
//  Created by AYUSH on 07/06/21.
//

import UIKit
import SDWebImage

class SellYourListingTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var _photosCollectionView: UICollectionView!
    @IBOutlet private weak var _listingNameLabel: UILabel!
    @IBOutlet private weak var _listingPriceLabel: UILabel!
    @IBOutlet private weak var _listingLocationLabel: UILabel!
    @IBOutlet private weak var _conditionProgressView: UIProgressView!
    
    private var listing: Listing?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _photosCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        _photosCollectionView.delegate = self
        _photosCollectionView.dataSource = self
        //_photosCollectionView.items
       // _photosCollectionView.layou
    }
    
    func apply(listing: Listing) {
        self.listing = listing
        _listingNameLabel.text = listing.name
        _listingPriceLabel.text = String(listing.price ?? 0)
        _listingLocationLabel.text = ( listing.location?.street ?? "") + ",\n" + (listing.location?.city ?? "")
        _conditionProgressView.progress = Float((listing.condition ?? 0)/10)
        _photosCollectionView.reloadData()
    }
    
    private func _initializeViews() {
        
    }
}

extension SellYourListingTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listing!.photos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _photosCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.apply(imageUrl: (listing?.photos?[indexPath.row]) ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: _photosCollectionView.bounds.width, height: _photosCollectionView.bounds.height)
    }
    
}

fileprivate class CollectionViewCell: UICollectionViewCell {
    
    private weak var _imageView: UIImageView!
    
    func apply(imageUrl: String) {
      
        _imageView.sd_setImage(with: URL(string: "http://localhost:5000/uploads/"+imageUrl), completed: nil)
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let i = UIImageView(frame: self.bounds)
        _imageView = i
        _imageView.contentMode = .scaleToFill
        addSubview(i)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
