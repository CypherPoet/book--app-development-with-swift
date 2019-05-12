//
//  BookingChargesTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingChargesTableViewCell: UITableViewCell {
    @IBOutlet private weak var numberOfNightsLabel: UILabel!
    @IBOutlet private weak var roomTypeShortCodeLabel: UILabel!
    @IBOutlet private weak var roomNightlyRateLabel: UILabel!
    @IBOutlet private weak var roomValetBotStatusLabel: UILabel!
    @IBOutlet private weak var roomValetBotRateLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    
    struct ViewModel {
        var roomTypeCode: String
        var roomNightlyRate: Int
        
        var hasValetBot: Bool
        var valetBotRate: Int
    }
    
    
    func configure(with viewModel: ViewModel) {
        
    }
}
