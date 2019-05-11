//
//  BookingDetailsViewControllerDelegate.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


protocol BookingDetailsViewControllerDelegate: AnyObject {
    
    func bookingDetailsViewController(
        _ controller: BookingDetailsViewController,
        didUpdateBooking booking: Booking
    )
    
}
