//
//  SettingsViewController.swift
//  Lets get thrifty
//
//  Created by Ayush Khanna on 26/06/2021.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {

    @IBOutlet private weak var _widthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var _heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var _ProfileimageView: UIImageView!
    @IBOutlet private weak var _topView: UIView!
    @IBOutlet private weak var _scrollView: UIScrollView!
    @IBOutlet private weak var _nameLabel: UILabel!
    
    private var maxImageDimentions: CGFloat!
    private var initialTopViewHeight: CGFloat!
    private let minImageDimentions: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initViews()

    }
    @IBAction func _logoutPressed(_ sender: Any) {
        viewModel.logoutUser()
    }
    
    private func _initViews() {
        maxImageDimentions = _ProfileimageView.frame.height
        initialTopViewHeight = _topView.frame.height
        let edgeInsets = UIEdgeInsets(top: initialTopViewHeight,
                                      left: 0,
                                      bottom: 0,
                                      right: 0)
        _scrollView.scrollIndicatorInsets = edgeInsets
        _scrollView.contentInset = edgeInsets
        _nameLabel.text = UserManager.shared.userName
    }
}

extension SettingsViewController:  UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + initialTopViewHeight
       
        
        let currentDimentions = (maxImageDimentions - offset) < minImageDimentions ? minImageDimentions : (maxImageDimentions - offset)
        
        print(currentDimentions)
        print(offset)
        
        _ProfileimageView.cornerRadius = currentDimentions/2
        _heightConstraint.constant = currentDimentions
        _widthConstraint.constant = currentDimentions
        
    }
    
}
