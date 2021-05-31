//
//  CardSwipingViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 22/05/21.
//

import UIKit

class CardSwipingViewController: BaseViewController<CardSwipingViewModel>, SwipableCardViewDataSource, SwipeableCardViewDelegate {
    func didSelect(card: SwipeableCardView, atIndex index: Int) {
        
    }
    
    
    @IBOutlet weak var _swipableCardView: SwipeableCardViewContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _swipableCardView.dataSource = self
        _swipableCardView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _swipableCardView.reloadData()
        
    }
    
    func numberOfCards() -> Int {
        swipableCardModels.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardView {
        let viewModel = swipableCardModels[index]
        let cardView = CardView()
        cardView.viewModel = viewModel
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        nil
    }
    
    var swipableCardModels: [SwipeableCellModel] {
        
        let models = [SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!), SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!),SwipeableCellModel(name: "Jeans", price: "100", location: "Dubai", image: UIImage(named: "tshirt")!)]
        
        
        return models
    }
 

}
