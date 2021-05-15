//
//  Loader.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import UIKit
import Lottie

class Loader: UIView {

    private weak var _animationView: AnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Required")
    }
    
    fileprivate func addLoader() {
        let animationView = AnimationView()
      //  animationView.contentMode = .scaleAspectFill
        animationView.animation = Animation.named("Loader")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 300)
        ])
        self._animationView = animationView
       
    }
    
    var ihidden: Bool = true {
        didSet {
            if !isHidden {
                    _performAnimate()
            }
        }
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if !self.isHidden {
            _performAnimate()
        }
    }
    
    private func _performAnimate() {
        self._animationView?.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .loop, completion: nil)
        
    }
}
