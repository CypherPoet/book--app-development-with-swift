//
//  CreateBookingModelController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class CreateBookingModelController {
    var firstName: String = ""
    var lastName: String = ""
    var emailAddress: String = ""
}


// MARK: - Core Methods

extension CreateBookingModelController {
    typealias Changes = (
        firstName: String,
        lastName: String,
        emailAddress: String
    )
    
    
//    func createBooking(with changes: Changes, then completionHandler: @escaping (Result<Booking, Error>) -> Void) {
    func createBooking(with changes: Changes, then completionHandler: @escaping (Result<String, Error>) -> Void) {
//        let newBooking = Booking(guest: <#T##Guest#>, room: <#T##Room#>, checkInDate: <#T##Date#>, checkOutDate: <#T##Date#>)
        
        completionHandler(.success("Test Booking"))
    }
}
