//
//  BookingDetailsViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class BookingDetailsViewController: UITableViewController {
    @IBOutlet weak var guestCell: BookingDetailGuestTableViewCell!
    @IBOutlet weak var datesCell: BookingDatesTableViewCell!
    @IBOutlet weak var roomImageCell: BookingRoomImageTableViewCell!
    @IBOutlet weak var numberOfNightsCell: BookingChargesTableViewCell!
    @IBOutlet weak var roomTypeCell: BookingChargesTableViewCell!
    @IBOutlet weak var valetBotCell: BookingChargesTableViewCell!
    @IBOutlet weak var totalPriceCell: BookingChargesTableViewCell!
    
    
    weak var delegate: BookingDetailsViewControllerDelegate?
    
    var booking: Booking!
    var bookingChargesTableViewModel: BookingChargesTableViewModel!
}


// MARK: - Computed Properties

extension BookingDetailsViewController {
    
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
        
        setupTableView(with: booking)
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
        tableView.reloadData()
        delegate?.bookingDetailsViewController(self, didUpdateBooking: booking)
    }
}


// MARK: - Private Helper Methods

private extension BookingDetailsViewController {

    func setupTableView(with booking: Booking) {
        bookingChargesTableViewModel = BookingChargesTableViewModel(
            roomTypeCode: booking.room.type.nameCode,
            roomNightlyRate: booking.room.type.price,
            numberOfNights: booking.numberOfNights,
            hasValetBot: booking.room.hasValetBot,
            valetBotRate: 4
        )
        
        setupBookingInfoCells(with: booking)
        tableView.reloadData()
    }
    
        
    func setupBookingInfoCells(with booking: Booking) {
        guestCell.viewModel = .init(
            guestFirstName: booking.guest.firstName,
            guestLastName: booking.guest.lastName,
            numberOfAdults: booking.guest.numberOfAdults,
            numberOfChildren: booking.guest.numberOfChildren
        )

        datesCell.viewModel = .init(
            checkInDate: booking.checkInDate,
            checkOutDate: booking.checkOutDate
        )
        
        roomImageCell.roomImage = booking.room.type.cellHeaderImage
    }
    
}
