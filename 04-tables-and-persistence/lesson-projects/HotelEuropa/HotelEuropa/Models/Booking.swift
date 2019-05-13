//
//  Booking.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Booking {
    let guest: Guest
    var room: Room
    var checkInDate: Date
    var checkOutDate: Date
}


// MARK: - Computed Properties

extension Booking {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
    
    
    static var defaultEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
    
    
    var numberOfNights: Int {
        let calendar = Calendar.current
        let checkInStartDay = calendar.startOfDay(for: checkInDate)
        let checkOutStartDay = calendar.startOfDay(for: checkOutDate)
        
        let comparisonComponents = calendar.dateComponents(
            [.day],
            from: checkInStartDay,
            to: checkOutStartDay
        )
        
        guard let nights = comparisonComponents.day else {
            fatalError("Unable to compute number of nights between check-in and -out dates.")
        }
        
        return nights
    }
    
}


// MARK: - Codable

extension Booking: Codable {}



