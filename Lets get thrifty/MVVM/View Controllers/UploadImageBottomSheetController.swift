//
//  UploadImageBottomSheetController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 27/05/21.
//

import UIKit

class ChooseImageBottomSheetController: BottomSheetController {
    @IBOutlet weak private var _contentView: UIView!
    
    override var contentView: UIView {
        _contentView
    }

    @IBAction func _galleryTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func _cameraTapped(_ sender: UIButton) {
        
    }
    
    var callback: ((UIImage)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insetsBackgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    


}

extension ChooseImageBottomSheetController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.init(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
        
        self.dismiss(animated: true) { [weak self] in
            self?.callback?(image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChooseImageBottomSheetController {
    struct Builder {
        static func build() -> ChooseImageBottomSheetController {
          let storyBoard = UIStoryboard.init(name: "Sell", bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: ChooseImageBottomSheetController.identifier) as! ChooseImageBottomSheetController
            
        }
    }
}

