//
//  BookingChargesViewModel.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct BookingChargesTableViewModel {
    var roomTypeCode: String
    var roomNightlyRate: Int
    var numberOfNights: Int
    
    var hasValetBot: Bool
    var valetBotRate: Int
}


extension BookingChargesTableViewModel {
    var roomNightlyRateString: String {
        return "\(roomNightlyRate) Satoshis"
    }
    
    var valetBotRatString: String {
        return "\(valetBotRate) Satoshis"
    }

    var totalPrice: Int {
        return 1
    }

    var totalPriceString: String {
        return "\(totalPrice) Satoshis"
    }
}
