//
//  BookingDetailsViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class BookingDetailsViewController: UIViewController {
    @IBOutlet private weak var infoTableView: UITableView!
    @IBOutlet weak var bookingChargesTableViewCell: BookingChargesTableViewCell!
    
    weak var delegate: BookingDetailsViewControllerDelegate?
    
    var booking: Booking?
    var infoTableViewDataSource: BookingInfoTableDataSource!
}


// MARK: - Lifecycle

extension BookingDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let booking = booking,
            delegate != nil
        else {
            preconditionFailure("Attempted to load BookingDetailsViewController without necessary data")
        }
        
        setupTableViews(with: booking)
    }
    
}


// MARK: - Navigation

extension BookingDetailsViewController {
    
    @IBAction func unwindFromCancelEditBooking(unwindSegue: UIStoryboardSegue) {}

    @IBAction func unwindFromSaveEditBooking(unwindSegue: UIStoryboardSegue) {
        guard
            let editBookingVC = unwindSegue.source as? CreateBookingViewController,
            let booking = editBookingVC.booking
        else { return }
        
        self.booking = booking
        updateTableViews(with: booking)
        delegate?.bookingDetailsViewController(self, didUpdateBooking: booking)
    }
}


// MARK: - Private Helper Methods

private extension BookingDetailsViewController {
    
    func setupTableViews(with booking: Booking) {
        let infoTableViewDataSource = BookingInfoTableDataSource(booking: booking)
        
        self.infoTableViewDataSource = infoTableViewDataSource
        infoTableView.dataSource = infoTableViewDataSource
    }
    
    
    func updateTableViews(with booking: Booking) {
        infoTableView.reloadData()
        
        bookingChargesTableViewCell.configure(
            with: .init(
                roomTypeCode: booking.room.type.nameCode,
                roomNightlyRate: booking.room.type.price,
                hasValetBot: booking.room.hasValetBot,
                valetBotRate: 4
            )
        )
    }
}
