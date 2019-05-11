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
    
}


// MARK: - Codable

extension Booking: Codable {}



