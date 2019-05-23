//
//  OrderConfirmationViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var confirmationResultLabel: UILabel!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    
    var viewModel: ViewModel!
}


// MARK: - Lifecycle

extension OrderConfirmationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No view model was set")
        
        configure(with: viewModel)
    }
}


// MARK: - Private Helper Methods

private extension OrderConfirmationViewController {
    
    func configure(with viewModel: ViewModel) {
        if let prepTimeText = viewModel.preparationTimeText {
            prepTimeLabel.isHidden = false
            prepTimeLabel.text = prepTimeText
        } else {
            prepTimeLabel.isHidden = true
        }
        
        confirmationResultLabel.text = viewModel.confirmationResult
        resultDescriptionLabel.text = viewModel.resultDescription
    }
    
}
