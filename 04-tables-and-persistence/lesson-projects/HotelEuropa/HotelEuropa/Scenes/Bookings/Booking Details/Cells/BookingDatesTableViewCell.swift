//
//  BookingDatesTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingDatesTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkInDateLabel: UILabel!
    @IBOutlet private weak var checkOutDateLabel: UILabel!
    
    
    struct ViewModel {
        var checkInDate: Date
        var checkOutDate: Date
    }
    
    
    func configure(with viewModel: ViewModel) {
        
    }


}
