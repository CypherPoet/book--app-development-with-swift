//
//  BookingDetailsViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit



class BookingDetailsViewController: UIViewController {
    weak var delegate: BookingDetailsViewControllerDelegate?
    
    var booking: Booking?
}



// MARK: - Navigation

extension BookingDetailsViewController {
    
    @IBAction func unwindFromSaveEditBooking(unwindSegue: UIStoryboardSegue) {
        guard
            let editBookingVC = unwindSegue.source as? CreateBookingViewController,
            let booking = editBookingVC.booking
        else { return }
        
        delegate?.bookingDetailsViewController(self, didUpdateBooking: booking)
    }
    
}
