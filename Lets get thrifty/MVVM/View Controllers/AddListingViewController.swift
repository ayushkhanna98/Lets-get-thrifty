//
//  AddListingViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 25/05/21.
//

import UIKit

class AddListingViewController: BaseViewController<AddListingViewModel> {
    
    @IBOutlet private var _imageViews: [TappableImageView]!
    @IBOutlet private weak var _nameTextField: UITextView!
    @IBOutlet private weak var _descriptionTextField: UITextView!
    @IBOutlet private weak var _conditionSlider: UISlider!
    @IBOutlet private weak var _priceLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupImageViewTapCallbacks()
    }
    
    @IBAction private func _continueTapped(_ sender: UIButton) {
        if validateEntries() {
            guard let priceStr = _priceLabel.text, let price = Int(priceStr) else {
                showError("Please enter a valid price for your Lising")
                return
            }
            let images = _imageViews.compactMap { image in
                image.image
            }
            let vc = AddYourAddressViewController.Builder.build(
                viewModel: AddYourAddressViewModel(
                    webserviceManager: self.viewModel.webserviceManager,
                    listingDetailsModel: ListingDetailsModel(
                        price: price, name: _nameTextField.text,
                        description: _descriptionTextField.text,
                        condition: Int(_conditionSlider.value * 10) ,
                        images: images
                    )))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction private func _cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func _setupImageViewTapCallbacks() {
        
        _imageViews.forEach { imageView in
            imageView.imageTapped = _imageTappedCallback
        }
    }
    
    private func _imageTappedCallback(tag: Int) {
        let vc = ChooseImageBottomSheetController.Builder.build()
        vc.callback = { [weak self] image in
            guard let s = self else { return }
            s.updateImage(image: image, tag: tag)
        }
        self.present(vc, animated: true)
    }
    
    private func updateImage(image: UIImage, tag: Int) {
        if let imageView = _imageViews.first(where: {$0.tag == tag}) {
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: {imageView.image = image },
                              completion: nil)
            
            guard tag - 1<self.viewModel.imageStates.count else {
                self.showError("Something went wrong")
                return
            }
            self.viewModel.imageStates[tag - 1] = .HasImage
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .white
        }
        
    }
    
    private func validateEntries() -> Bool {
        for state in viewModel.imageStates {
            if state == AddListingViewModel.ImageState.NoImage {
                showError("Please add all images")
                return false
            }
        }
        
        if _nameTextField.text.isEmpty {
            showError("Please enter a name for your Listing")
            return false
        }
        
        if _nameTextField.text.count > 30 {
            showError("Please enter a shorter name for your listing")
            return false
        }
        
        if _descriptionTextField.text.isEmpty {
            showError("Please enter a description for your Listing")
            return false
        }
        
        if _descriptionTextField.text.count > 30 {
            showError("Please enter a shorter description for your listing")
            return false
        }
        
        guard let priceStr = _priceLabel.text, !priceStr.isEmpty ,let price = Int(priceStr), price < 1000 else {
            showError("Please enter a valid price for your Listing")
            return false
        }
        
        return true
    }
    
}

extension AddListingViewController {
    struct Builder {
        static func build() -> AddListingViewController {
          let storyBoard = UIStoryboard.init(name: "Sell", bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: AddListingViewController.identifier) as! AddListingViewController
            
        }
    }
}


class TappableImageView: UIImageView {
    
    var imageTapped: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGestRec = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        self.addGestureRecognizer(tapGestRec)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tapGestRec = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        self.addGestureRecognizer(tapGestRec)
        self.isUserInteractionEnabled = true
    }
    
    @objc func imageViewTapped() {
        imageTapped?(self.tag)
    }
    
    
}


