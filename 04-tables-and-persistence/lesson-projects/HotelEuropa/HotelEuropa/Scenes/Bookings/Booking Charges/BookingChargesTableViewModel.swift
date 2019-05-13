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
    var roomNightlyRateText: String {
        return "\(roomNightlyRate) Satoshis"
    }
    
    var roomTypeText: String {
        return "Room Type: \(roomTypeCode)"
    }
    
    var valetBotRateText: String {
        return "\(valetBotRate) Satoshis"
    }
    
    var valetBotStatusText: String {
        return "Valet Bot: \(hasValetBot ? "Yes" : "No")"
    }

    var totalPrice: Int {
        let botExpense = hasValetBot ? valetBotRate : 0
        return (roomNightlyRate + botExpense) * numberOfNights
    }

    var totalPriceText: String {
        return "\(totalPrice) Satoshis"
    }
}
