//
//  MenuItemDetailViewController+ViewModel.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension MenuItemDetailViewController {
    
    struct ViewModel {
        var price: Int
        var itemName: String
        var itemDescription: String
        var headerImage: UIImage?
    }
}


// MARK: - Computed Properties

extension MenuItemDetailViewController.ViewModel {
    
    var priceText: String {
        return "\(price) sats"
    }
}
