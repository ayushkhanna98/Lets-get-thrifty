//
//  AlertViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import UIKit
import Lottie

class AlertViewController: UIViewController {

    @IBOutlet private weak var _backgroundView: UIView!
    @IBOutlet private weak var _animationView: UIView!
    @IBOutlet private weak var _secondButton: UIButton!
    @IBOutlet private weak var _dismissButton: UIButton!
    @IBOutlet private weak var _titleLabel: UILabel!
    @IBOutlet private weak var _messageLabel: UILabel!
    
    private var _animation: AnimationView!
    
    enum AlertType: String {
        case Error = "error"
        case Information
        case Warning = "warning"
        case Success = "Success"
    }
    
    var callback: (()->())?
    
    var alertType: AlertType!
    var showSecondButton = false
    var secondButtonTitle = ""
    var alertTitle: String!
    var message: String!
    var dismissAfter: Double?
    var dismisCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initializeViews()
        _setupDismissAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _animation.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .loop, completion: nil)
    }
    @IBAction func _secondButtonTapped(_ sender: Any) {
        callback?()
    }
    
    @IBAction func _dismissTapped(_ sender: Any) {
        dismisCallback?()
        self.dismiss(animated: true)
    }
    
    private func _initializeViews() {
        _backgroundView.layer.cornerRadius = 40
        _backgroundView.layer.borderWidth = 1
        _backgroundView.layer.borderColor = UIColor.black.cgColor
        _animation = AnimationView(name: "\(alertType.rawValue)")
        _animation.frame = _animationView.bounds
        _animationView.addSubview(_animation)
        _secondButton.isHidden = !showSecondButton
        _secondButton.setTitle(secondButtonTitle, for: .normal)
        _dismissButton.layer.cornerRadius = 10
        _dismissButton.layer.borderWidth = 0.5
        _dismissButton.layer.borderColor = UIColor.black.cgColor
        _secondButton.layer.cornerRadius = 10
        _secondButton.layer.borderWidth = 0.5
        _secondButton.layer.borderColor = UIColor.black.cgColor
        _messageLabel.text = message
        _titleLabel.text = alertTitle
    }
    
    private func _setupDismissAction() {
     
        if let time = dismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) { [weak self] in
                let dismissCallback = self?.dismisCallback
                self?.dismiss(animated: true) {
                    dismissCallback?()
                }
            }
        }
    }
    
    

}
