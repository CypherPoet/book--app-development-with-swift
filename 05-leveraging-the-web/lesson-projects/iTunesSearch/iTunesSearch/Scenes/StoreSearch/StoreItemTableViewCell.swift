//
//  StoreItemTableViewCell.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class StoreItemTableViewCell: UITableViewCell {
    

    var viewModel: StoreItemTableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            textLabel?.text = viewModel.title
            detailTextLabel?.text = viewModel.subtitle
            imageView?.image = viewModel.thumbnailImage
        }
    }

}
