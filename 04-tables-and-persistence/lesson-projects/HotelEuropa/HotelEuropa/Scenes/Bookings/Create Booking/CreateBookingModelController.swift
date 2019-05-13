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
        checkOutDate: Date,
        numberOfAdults: Int,
        numberOfChildren: Int,
        hasValetBot: Bool,
        roomChoice: RoomType?
    )
    
    enum NewBookingError: Error {
        case invalidGuest(_ reason: String)
        case missingRoomChoice
    }
    
    func createBooking(with changes: Changes, then completionHandler: @escaping (Result<Booking, NewBookingError>) -> Void) {
        let (firstName, lastName, emailAddress) = (changes.0, changes.1, changes.2)
        
        guard [firstName, lastName, emailAddress].allSatisfy({ !$0.isEmpty }) else {
            return completionHandler(.failure(.invalidGuest("Names and email can't be empty")))
        }
        
        let (numberOfAdults, numberOfChildren) = (changes.numberOfAdults, changes.numberOfChildren)
        
        guard [numberOfAdults, numberOfChildren].allSatisfy( { $0 >= 0 }) else {
            return completionHandler(
                .failure(.invalidGuest("Number of adults and children can't be negative"))
            )
        }
        
        guard let roomType = changes.roomChoice else {
            return completionHandler(.failure(.missingRoomChoice))
        }
    
        let guest = Guest(
            firstName: firstName,
            lastName: lastName,
            emailAddress: emailAddress,
            numberOfAdults: numberOfAdults,
            numberOfChildren: numberOfChildren
        )
        
        let room  = Room(number: 0, type: roomType, hasValetBot: changes.hasValetBot)
        
        let newBooking = Booking(
            guest: guest,
            room: room,
            checkInDate: changes.checkInDate,
            checkOutDate: changes.checkOutDate
        )
        
        completionHandler(.success(newBooking))
    }
}
