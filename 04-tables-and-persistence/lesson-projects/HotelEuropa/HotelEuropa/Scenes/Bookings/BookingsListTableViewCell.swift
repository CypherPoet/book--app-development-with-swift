//
//  BookingsListTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class BookingsListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    
    var viewModel: BookingCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
        }
    }
}
