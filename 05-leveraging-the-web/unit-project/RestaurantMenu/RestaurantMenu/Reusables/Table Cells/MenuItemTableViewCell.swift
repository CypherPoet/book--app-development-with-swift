//
//  MenuItemTableViewCell.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var itemPriceLabel: UILabel!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(with: viewModel)
        }
    }
}


// MARK: - Private Helper Methods

private extension MenuItemTableViewCell {
    
    func configure(with viewModel: ViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
        itemTitleLabel.text = viewModel.itemTitle
        itemPriceLabel.text = viewModel.itemPriceText
    }
}
