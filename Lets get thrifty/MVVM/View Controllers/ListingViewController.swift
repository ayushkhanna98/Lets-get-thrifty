//
//  ListingViewController.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 15/06/2021.
//
import UIKit
import MapKit

class ListingViewController: BaseViewController<ListingViewModel>, MKMapViewDelegate {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _listingName: UILabel!
    @IBOutlet weak var _listingPrice: UILabel!
    @IBOutlet weak var _listingDescription: UILabel!
    @IBOutlet weak var _listingLocation: UILabel!
    @IBOutlet weak var _listingConditionProgress: UIProgressView!
    @IBOutlet weak var _mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initializeViews()
        _initializeMapView()
        _collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // self.disableHero()
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == _collectionView, !viewModel.didInitializeCollectionView, let initialIndex = viewModel.initialCollectionViewIndex {
            _collectionView.scrollToItem(at:IndexPath(item: initialIndex, section: 0), at: .right, animated: false)
            viewModel.didInitializeCollectionView = true
            _collectionView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    @IBAction func _editButtonTapped(_ sender: UIButton) {
    }
    
    private func _initializeViews() {
        _collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _listingName.text = viewModel.listing?.name
        _listingPrice.text = viewModel.listing?.listingPrice
        _listingDescription.text = viewModel.listing?.description
        _listingLocation.text = "\(viewModel.listing?.location?.street ?? "") \n \(viewModel.listing?.location?.city ?? "") \n \(viewModel.listing?.location?.state ?? "") \n \(viewModel.listing?.location?.country ?? "") \n"
        _mapView.delegate = self
        
    }
    
    private func _initializeMapView() {
        let annotation = MapAnnotation(
            coordinate:
                CLLocationCoordinate2D(
                    latitude: viewModel.listing!.location!.coordinates![0],
                    longitude: viewModel.listing!.location!.coordinates![1]),
            title: "Location",
            info: "")
        
        _mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1))
        
        self._mapView.setRegion(region, animated: true)
    }
    
    @IBAction func _contactSellerTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func _backButtom(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ListingViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listing?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.apply(imageUrl: viewModel.listing?.photos?[indexPath.row] ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: _collectionView.bounds.width, height: _collectionView.bounds.height)
    }
}

extension ListingViewController {
    struct Builder {
        static func build(model: ListingViewModel) -> ListingViewController  {
            let storyBoard = UIStoryboard.init(name: "Sell", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ListingViewController.identifier) as! ListingViewController
            vc.viewModel = model
            return vc
        }
    }
}
