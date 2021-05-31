//
//  AddListingViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 25/05/21.
//

import UIKit

class AddListingViewController: BaseViewController<AddListingViewModel> {
    
    @IBOutlet var _imageViews: [TappableImageView]!
    
    @IBAction func _cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupImageViewTapCallbacks()
    }
    
    private func _setupImageViewTapCallbacks() {
        
        _imageViews.forEach { imageView in
            imageView.imageTapped = _imageTappedCallback
        }
    }
    
    private func _imageTappedCallback(tag: Int) {
        let vc = ChooseImageBottomSheetController.Builder.build()
        vc.callback = { [weak self] image in
            let imageView = self?._imageViews.first() {$0.tag == tag}
            imageView?.image = image
            self?.viewModel.imageStates[tag] = .HasImage
            imageView?.contentMode = .scaleAspectFit
            imageView?.backgroundColor = .white
        }
        self.present(vc, animated: true)
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


