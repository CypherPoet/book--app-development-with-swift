//
//  BookingDatesTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class BookingDatesTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkInDateLabel: UILabel!
    @IBOutlet private weak var checkOutDateLabel: UILabel!
    
    
    struct ViewModel {
        var checkInDate: Date
        var checkOutDate: Date
    }
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(with: viewModel)
        }
    }
}



// MARK: - ViewModel Configuration

extension BookingDatesTableViewCell {
    
    private func configure(with viewModel: ViewModel) {
        checkInDateLabel.text = viewModel.formattedCheckInDate
        checkOutDateLabel.text = viewModel.formattedCheckOutDate
    }
    
}


// MARK: - ViewModel Computeds

extension BookingDatesTableViewCell.ViewModel {
    var displayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        return formatter
    }
    
    var formattedCheckInDate: String {
        return displayDateFormatter.string(from: checkInDate)
    }
    
    var formattedCheckOutDate: String {
        return displayDateFormatter.string(from: checkOutDate)
    }
    
}
