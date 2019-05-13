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
    
    
    func configure(with viewModel: ViewModel) {
        checkInDateLabel.text = viewModel.formattedCheckInDate
        checkOutDateLabel.text = viewModel.formattedCheckOutDate
    }
}


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
