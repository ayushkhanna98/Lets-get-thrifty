//
//  CardView.swift
//  Lets get thrifty
//
//  Created by AYUSH on 21/05/21.
//

import UIKit

class CardView: SwipeableCardView, InternalSwipingDelegate {
    
    
    func didSwipe(swipeDirection: SwipeDirection, swipePercentage: CGFloat) {
        _swipeIndicationView.backgroundColor = .red
        _swipeIndicationView.alpha = swipePercentage
        
    }
    
    
    @IBOutlet weak private var _imageView: UIImageView!
    @IBOutlet weak private var _nameLabel: UILabel!
    @IBOutlet weak private var _locationLabel: UILabel!
    @IBOutlet weak private var _priceLabel: UILabel!
    @IBOutlet weak var _bgContainerView: UIView!
    @IBOutlet weak var _swipeIndicationView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    var viewModel: SwipeableCellModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    private func configure(forViewModel viewModel: SwipeableCellModel?) {
        if let viewModel = viewModel {
            _nameLabel.text = viewModel.name
            _priceLabel.text = viewModel.price
            _imageView.image = viewModel.image
            
            _bgContainerView.layer.cornerRadius = 14.0
        }
        
        internalDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _bgContainerView.layer.borderWidth = 1
        _bgContainerView.layer.borderColor = UIColor.black.cgColor
        
        configureShadow()
    }
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: CardView.kInnerMargin,
                                              y: CardView.kInnerMargin,
                                              width: bounds.width - (2 * CardView.kInnerMargin),
                                              height: bounds.height - (2 * CardView.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        self.applyShadow(width: CGFloat(10), height: CGFloat(10))
    }
    
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
}
