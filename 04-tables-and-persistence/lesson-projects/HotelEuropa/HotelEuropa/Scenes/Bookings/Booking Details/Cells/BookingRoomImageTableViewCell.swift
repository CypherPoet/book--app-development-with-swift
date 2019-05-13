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
    @IBOutlet private weak var roomTypeNameLabel: UILabel!

    
    var roomImage: UIImage? {
        didSet {
            guard let roomImage = roomImage else { return }
            
            roomImageView.image = roomImage
        }
    }
    
    var roomTypeName: String = "" {
        didSet {
            roomTypeNameLabel.text = roomTypeName
        }
    }
}
