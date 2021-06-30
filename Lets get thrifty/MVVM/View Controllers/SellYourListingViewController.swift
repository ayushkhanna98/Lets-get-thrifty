//
//  SellViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 24/05/21.
//

import UIKit

class SellYourListingViewController: BaseViewController<SellYourListingViewModel> {

    @IBOutlet private weak var _topView: UIView!
    @IBOutlet private weak var _tableView: UITableView!
    @IBOutlet private weak var _topViewHeightAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
        _bindViewModel()
        _tableView.register(UINib(nibName: "SellYourListingTableViewCell", bundle: nil), forCellReuseIdentifier: "SellYourListingTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._tableView.reloadData()
        self.enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.disableHero()
    }
    
    private func _bindViewModel() {
        self.viewModel.listings.bind {[weak self] listings in
            print(listings)
            self?._tableView.reloadData()
        }.disposed(by: disposableBag)
    }
    
    private func _headerTapped() {
        let vc = AddListingNavigationController.Builder.build(deletage: self)
        self.present(vc, animated: true,
                     completion: nil)
        
    }
    
    private func _setupViews() {
        _topView.layer.cornerRadius = 15
        _topView.layer.borderWidth = 1
        _topView.layer.borderColor = UIColor.black.cgColor
        
        let header = UINib.init(nibName: SellYourListingTableViewHeader.identifier, bundle: nil)
        self._tableView.register(header, forHeaderFooterViewReuseIdentifier: SellYourListingTableViewHeader.identifier)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.contentInset.top = -19
        _topViewHeightAnchor.constant = navigationBarHeightWithInsets + 20
        
    }
}

extension SellYourListingViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.listings.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellYourListingTableViewCell", for: indexPath) as! SellYourListingTableViewCell
        cell.apply(listing: viewModel.listings.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: SellYourListingTableViewHeader.identifier) as! SellYourListingTableViewHeader
        header.userDidTap = _headerTapped
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SellYourListingTableViewCell else { return }
        let vc = ListingViewController.Builder.build(model: ListingViewModel(webserviceManager: self.viewModel.webserviceManager,
                                                                             listing: self.viewModel.listings.value[indexPath.row],
                                                                             initialCollectionViewIndex:cell.currentSelectedIndex))
        vc.hidesBottomBarWhenPushed = true
//        (cell._photosCollectionView.cellForItem(at: IndexPath(row: cell.currentSelectedIndex, section: 1) ) as!  ImageCollectionViewCell)._imageView.heroID = "x"
        //vc._collectionView.heroID = "x"
        cell.heroID = "x"
        
        showHero(vc)
    }

}

extension SellYourListingViewController : ListingDelegate {
    func didAddNewListing(listing: Listing) {
        self.viewModel.addNewListing(listing: listing)
    }
}
