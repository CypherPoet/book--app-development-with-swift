//
//  CreateBookingModelController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class CreateBookingModelController {

}


// MARK: - Computed Properties

extension CreateBookingModelController {

}


// MARK: - Core Methods

extension CreateBookingModelController {
    typealias Changes = (
        firstName: String,
        lastName: String,
        emailAddress: String,
        checkInDate: Date,
        checkOutDate: Date
    )
    
    enum NewBookingError: Error {
        case invalidGuest
    }
    
    func createBooking(with changes: Changes, then completionHandler: @escaping (Result<Booking, NewBookingError>) -> Void) {
        let (firstName, lastName, emailAddress) = (changes.0, changes.1, changes.2)
        
        guard [firstName, lastName, emailAddress].allSatisfy({ !$0.isEmpty }) else {
            return completionHandler(.failure(.invalidGuest))
        }
        
        
        let guest = Guest(firstName: firstName, lastName: lastName, emailAddress: emailAddress)
        let roomType = RoomType(id: UUID().uuidString, name: .suite, nameCode: .suite, price: 1_000_000)
        let room  = Room(number: 0, type: roomType, hasValetBot: true)
        
        let newBooking = Booking(
            guest: guest,
            room: room,
            checkInDate: changes.checkInDate,
            checkOutDate: changes.checkOutDate
        )
        
        completionHandler(.success(newBooking))
    }
}
