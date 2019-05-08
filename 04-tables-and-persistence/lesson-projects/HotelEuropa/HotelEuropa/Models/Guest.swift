//
//  Guest.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

/**
 The primary guest that belongs to a Booking.
 */
struct Guest {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    let numberOfAdults: Int
    let numberOfChildren: Int
}
