//
//  BookingDetailsViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class BookingDetailsViewController: UITableViewController {
    @IBOutlet private weak var numberOfNightsLabel: UILabel!
    @IBOutlet private weak var roomTypeShortCodeLabel: UILabel!
    @IBOutlet private weak var roomNightlyRateLabel: UILabel!
    @IBOutlet private weak var roomValetBotStatusLabel: UILabel!
    @IBOutlet private weak var roomValetBotRateLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    weak var delegate: BookingDetailsViewControllerDelegate?
    
    var booking: Booking!
    var bookingChargesTableViewModel: BookingChargesTableViewModel!

    var detailsTableDataSource: BookingDetailsTableDataSource!
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
        
        detailsTableDataSource = makeDetailsTableDataSource(with: booking)
        
        tableView.dataSource = detailsTableDataSource
        tableView.reloadData()
    }
    
    
    func makeDetailsTableDataSource(with booking: Booking) -> BookingDetailsTableDataSource {
        return BookingDetailsTableDataSource(
            booking: booking,
            cellConfigurator: { [weak self] (booking, cell) in
                self?.configure(cell, with: booking)
            }
        )
    }
    
    
    // MARK: - Cell Configuration
    
    func configure(_ cell: UITableViewCell, with booking: Booking) {
        switch cell {
        case let chargesCell as BookingChargesTableViewCell:
            configure(chargesCell, with: bookingChargesTableViewModel)
        case let guestCell as BookingDetailGuestTableViewCell:
            guestCell.configure(with: BookingDetailGuestTableViewCell.ViewModel(
                guestFirstName: booking.guest.firstName,
                guestLastName: booking.guest.lastName
                )
            )
        case let datesCell as BookingDatesTableViewCell:
            datesCell.configure(with: BookingDatesTableViewCell.ViewModel(
                checkInDate: booking.checkInDate,
                checkOutDate: booking.checkOutDate
            )
        )
        default:
            break
        }
    }
    
    
    func configure(_ chargesCell: BookingChargesTableViewCell, with viewModel: BookingChargesTableViewModel) {
        
    }
    
}
