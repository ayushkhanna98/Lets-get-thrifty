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
        _topView.layer.cornerRadius = 15
        _topView.layer.borderWidth = 1
        _topView.layer.borderColor = UIColor.black.cgColor
        
        let header = UINib.init(nibName: SellYourListingTableViewHeader.identifier, bundle: nil)
        self._tableView.register(header, forHeaderFooterViewReuseIdentifier: SellYourListingTableViewHeader.identifier)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.contentInset.top = 25
        _topViewHeightAnchor.constant = navigationBarHeightWithInsets + 20
        

    }
    
    private func _headerTapped() {
       // let vc = AddListingViewController.Builder.build()
        let nc = UIStoryboard.init(name: "Sell", bundle: nil).instantiateViewController(identifier: "AddListingNavController")
        self.present(nc, animated: true, completion: nil)
    }

}

extension SellYourListingViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: SellYourListingTableViewHeader.identifier) as! SellYourListingTableViewHeader
        header.userDidTap = _headerTapped
        return header
    }
    
    
    
    
    
    
    
}
