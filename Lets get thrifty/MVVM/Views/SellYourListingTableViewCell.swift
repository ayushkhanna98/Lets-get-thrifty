//
//  SellYourListingTableViewCell.swift
//  Lets get thrifty
//
//  Created by AYUSH on 07/06/21.
//

import UIKit
import SDWebImage

class SellYourListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var _photosCollectionView: UICollectionView!
    @IBOutlet private weak var _listingNameLabel: UILabel!
    @IBOutlet private weak var _listingPriceLabel: UILabel!
    @IBOutlet private weak var _listingLocationLabel: UILabel!
    @IBOutlet private weak var _conditionProgressView: UIProgressView!
    
    private var listing: Listing?
    
    var currentSelectedIndex: Int {
        guard _photosCollectionView.contentOffset.x != 0 else { return 0}
        
        return Int((_photosCollectionView.contentOffset.x/_photosCollectionView.contentSize.width) * CGFloat(listing?.photos?.count ?? 0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _photosCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        _photosCollectionView.delegate = self
        _photosCollectionView.dataSource = self
    }
    
    func apply(listing: Listing) {
        self.listing = listing
        _listingNameLabel.text = listing.name
        _listingPriceLabel.text = String(listing.price ?? 0)
        _listingLocationLabel.text = ( listing.location?.street ?? "") + ",\n" + (listing.location?.city ?? "")
        _conditionProgressView.progress = Float((listing.condition ?? 0))/10
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
        let cell = _photosCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.apply(imageUrl: (listing?.photos?[indexPath.row]) ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: _photosCollectionView.bounds.width, height: _photosCollectionView.bounds.height)
    }
    
}


