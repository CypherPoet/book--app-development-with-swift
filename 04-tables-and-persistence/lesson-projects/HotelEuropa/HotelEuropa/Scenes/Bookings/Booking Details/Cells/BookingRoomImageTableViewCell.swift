//
//  BookingRoomImageTableViewCell.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingRoomImageTableViewCell: UITableViewCell {
    @IBOutlet private weak var roomImageView: UIImageView!
    @IBOutlet private weak var numberOfAdultsLabel: UILabel!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    
    
    struct ViewModel {
        var numberOfAdults: Int
        var numberOfChildren: Int
        var roomImage: UIImage
    }
    
    
    func configure(with viewModel: ViewModel) {
        
    }
}
