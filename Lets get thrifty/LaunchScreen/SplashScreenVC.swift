//
//  ViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 24/04/21.
//

import UIKit
import Lottie

class SplashScreenVC: UIViewController {

    var _animationView: AnimationView!
    @IBOutlet weak var tshirtImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labeRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var tshirtLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var labelLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var tshirtRightAnchor: NSLayoutConstraint!
    
    var callback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _animationView = .init(name: "sneaker-outlined")
        _animationView.frame = view.bounds
        _animationView.isHidden = true
        view.addSubview(_animationView)
        //view.bringSubviewToFront(_animationView)
        
        _animationView.backgroundColor = .clear
        UIView.animate(withDuration: 0.5) {
            self.labeRightAnchor.constant = self.view.bounds.width
            self.labelLeftAnchor.constant = -self.view.bounds.width
            self.tshirtRightAnchor.constant = -self.view.bounds.width
            self.tshirtLeftAnchor.constant = self.view.bounds.width
            self.view.layoutIfNeeded()
        } completion: { (bool) in
            self._animationView.isHidden = false
            self.label.isHidden = true
            self.tshirtImage.isHidden = true
            self._animationView.play { (didComplete) in
                self.callback?()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}

