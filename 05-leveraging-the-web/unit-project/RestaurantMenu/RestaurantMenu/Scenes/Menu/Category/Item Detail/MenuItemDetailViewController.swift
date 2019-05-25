//
//  MenuItemDetailViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var itemDescriptionLabel: UILabel!
    @IBOutlet private weak var orderButton: UIButton!
    
    var itemAddedToOrder: (() -> Void)!
    var modelController: MenuModelController!
    
    var viewModel: ViewModel! {
        didSet {
            if isViewLoaded { configure(with: viewModel) }
        }
    }
    
    private var hasInsertedHeaderImage = false
}


// MARK: - Lifecycle

extension MenuItemDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No view model was found")
        assert(modelController != nil, "No model controller was set")
        assert(itemAddedToOrder != nil, "No callback for adding an item to an order was found")
        
        setupUI()
        configure(with: viewModel)
    }

}


// MARK: - Event handling

extension MenuItemDetailViewController {
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        animateButtonTap(for: sender)
        
        itemAddedToOrder()
    }
}


// MARK: - Private Helper Methods

private extension MenuItemDetailViewController {
    
    func setupUI() {
        orderButton.layer.cornerRadius = 5.0
    }
    
    
    func configure(with viewModel: ViewModel) {
        itemNameLabel.text = viewModel.itemName
        priceLabel.text = viewModel.priceText
        itemDescriptionLabel.text = viewModel.itemDescription
        headerImageView.image = viewModel.headerImage
    }
    
    
    func animateButtonTap(for button: UIButton) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                button.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                button.transform = .identity
            }
        )
    }
}
