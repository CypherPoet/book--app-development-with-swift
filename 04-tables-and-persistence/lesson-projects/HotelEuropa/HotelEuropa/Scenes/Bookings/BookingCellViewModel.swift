//
//  BookingCellViewModel.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

struct BookingCellViewModel {
    var guestFirstName: String
    var guestLastName: String
    var checkInDate: Date
    var checkOutDate: Date
    var roomTypeName: String
}


extension BookingCellViewModel {
    
    private var subtitleDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }
    
    
    private var formattedCheckInDate: String {
        return subtitleDateFormatter.string(for: checkInDate)!
    }
    
    
    private var formattedCheckOutDate: String {
        return subtitleDateFormatter.string(for: checkOutDate)!
    }
    
    
    var title: String {
        return "\(guestFirstName) \(guestLastName)"
    }
    

    var subtitle: String {
        return "\(formattedCheckInDate) - \(formattedCheckOutDate): \(roomTypeName)"
    }
}

