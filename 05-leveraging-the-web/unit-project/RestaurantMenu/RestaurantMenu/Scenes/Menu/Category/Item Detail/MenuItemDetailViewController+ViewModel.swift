//
//  MenuItemDetailViewController+ViewModel.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation



extension MenuItemDetailViewController {
    
    struct ViewModel {
        var price: Int
        var itemName: String
        var itemDescription: String

        var itemImageURL: URL
        var itemImageData: Data?
    }
}


// MARK: - Initializer to allow for empty image data

extension MenuItemDetailViewController.ViewModel {
    
    init(
        price: Int,
        itemName: String,
        itemDescription: String,
        itemImageURL: URL
    ) {
        self.price = price
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemImageURL = itemImageURL
        self.itemImageData = nil
    }
}


// MARK: - Computed Properties

extension MenuItemDetailViewController.ViewModel {
    
    var priceText: String {
        return "\(price) sats"
    }
}
