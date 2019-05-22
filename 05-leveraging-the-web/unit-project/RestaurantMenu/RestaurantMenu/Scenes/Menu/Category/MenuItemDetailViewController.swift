//
//  MenuItemDetailViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    var viewModel: ViewModel!
}


// MARK: - Lifecycle

extension MenuItemDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard viewModel != nil else {
            preconditionFailure("No view model was found")
        }
        
        configure(with: viewModel)
    }

}


extension MenuItemDetailViewController {
    
    struct ViewModel {
        var itemImageURL: URL
    }
    
}


// MARK: - Private Helper Methods

private extension MenuItemDetailViewController {
    
    func configure(with viewModel: ViewModel) {
        
    }
    
}
