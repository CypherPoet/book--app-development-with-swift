//
//  BookingDetailGuestTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingDetailGuestTableViewCell: UITableViewCell {
    @IBOutlet private weak var guestNameLabel: UILabel!

    struct ViewModel {
        var guestFirstName: String
        var guestLastName: String
    }
    
    
    func configure(with viewModel: ViewModel) {
        
    }

}
