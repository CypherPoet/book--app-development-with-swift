//
//  BookingChargesViewModel.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct BookingChargesTableViewModel {
    var roomTypeCode: String?
    var roomNightlyRate: Int?
    var numberOfNights: Int?
    
    var hasValetBot: Bool?
    var valetBotRate: Int?
}


extension BookingChargesTableViewModel {
    
    var numberOfNightsText: String {
        if let numberOfNights = numberOfNights {
            return "\(numberOfNights)"
        } else {
            return "N/A"
        }
    }
    
    
    var totalRoomPriceText: String {
        if
            let roomNightlyRate = roomNightlyRate,
            let numberOfNights = numberOfNights
        {
            return "\(roomNightlyRate * numberOfNights) Satoshis"
        } else {
            return "N/A"
        }
    }
    
    
    var roomTypeText: String {
        if let roomTypeCode = roomTypeCode {
            return "Room Type: \(roomTypeCode)"
        } else {
            return "N/A"
        }
    }
    

    var valetBotExpense: Int? {
        if
            let hasValetBot = hasValetBot,
            let valetBotRate = valetBotRate,
            let numberOfNights = numberOfNights
        {
            return hasValetBot ? (valetBotRate * numberOfNights) : 0
        } else {
            return nil
        }
    }
    
    
    var valetBotPriceText: String {
        if let valetBotExpense = valetBotExpense {
            return "\(valetBotExpense) Satoshis"
        } else {
            return "N/A"
        }
    }
    
    
    var valetBotStatusText: String {
        let hasValetBot = self.hasValetBot ?? false
        
        return "Valet Bot: \(hasValetBot ? "Yes" : "No")"
    }
    

    var totalPrice: Int? {
        if
            let valetBotExpense = valetBotExpense,
            let roomNightlyRate = roomNightlyRate,
            let numberOfNights = numberOfNights
        {
            return (roomNightlyRate + valetBotExpense) * numberOfNights
        } else {
            return nil
        }
    }

    
    var totalPriceText: String {
        if let totalPrice = totalPrice {
            return "\(totalPrice) Satoshis"
        } else {
            return "N/A"
        }
    }
}
