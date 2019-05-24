//
//  MenuItemTableViewCell+ViewModel.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension MenuItemTableViewCell {
    struct ViewModel {
        var itemTitle: String
        var itemPrice: Int
        var thumbnailImage: UIImage?
    }
}


// MARK: - Computed Properties

extension MenuItemTableViewCell.ViewModel {
    
    var itemPriceText: String {
        return "\(itemPrice) sats"
    }
    
}
