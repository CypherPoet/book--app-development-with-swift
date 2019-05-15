//
//  BookingDetailGuestTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class BookingDetailGuestTableViewCell: UITableViewCell {
    @IBOutlet private weak var guestNameLabel: UILabel!
    @IBOutlet private weak var numberOfAdultsLabel: UILabel!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    
    
    struct ViewModel {
        var guestFirstName: String
        var guestLastName: String
        var numberOfAdults: Int
        var numberOfChildren: Int
    }
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(with: viewModel)
        }
    }
}


// MARK: - ViewModel Configuration

extension BookingDetailGuestTableViewCell {
    
    private func configure(with viewModel: ViewModel) {
        guestNameLabel.text = "\(viewModel.guestFirstName) \(viewModel.guestLastName)"
        numberOfAdultsLabel.text = viewModel.numberOfAdultsText
        numberOfChildrenLabel.text = viewModel.numberOfChildrenText
    }
    
}


// MARK: - ViewModel Computed Properties

extension BookingDetailGuestTableViewCell.ViewModel {
    
    var numberOfAdultsText: String {
        if numberOfAdults == 1 {
            return "1 Adult"
        } else {
            return "\(numberOfAdults) Adults"
        }
    }
    
    
    var numberOfChildrenText: String {
        if numberOfChildren == 1 {
            return "1 Child"
        } else {
            return "\(numberOfChildren) Children"
        }
    }
}
