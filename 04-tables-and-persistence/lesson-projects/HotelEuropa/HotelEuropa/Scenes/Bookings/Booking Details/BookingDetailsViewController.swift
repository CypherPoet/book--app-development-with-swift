//
//  BookingDetailsViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class BookingDetailsViewController: UITableViewController {
    @IBOutlet private weak var guestCell: BookingDetailGuestTableViewCell!
    @IBOutlet private weak var datesCell: BookingDatesTableViewCell!
    @IBOutlet private weak var roomImageCell: BookingRoomImageTableViewCell!
    
    @IBOutlet private weak var numberOfNightsLabel: UILabel!
    @IBOutlet private weak var roomTypeShortCodeLabel: UILabel!
    @IBOutlet private weak var totalRoomPriceLabel: UILabel!
    @IBOutlet private weak var roomValetBotStatusLabel: UILabel!
    @IBOutlet private weak var totalValetBotPriceLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    
    weak var delegate: BookingDetailsViewControllerDelegate?
    
    var booking: Booking!
}


// MARK: - Computed Properties

extension BookingDetailsViewController {
    
    var bookingChargesTableViewModel: BookingChargesTableViewModel {
        return BookingChargesTableViewModel(
            roomTypeCode: booking.room.type.nameCode,
            roomNightlyRate: booking.room.type.price,
            numberOfNights: booking.numberOfNights,
            hasValetBot: booking.hasValetBot,
            valetBotRate: Booking.valetBotRate
        )
    }
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
            let editBookingVC = unwindSegue.source as? AddEditBookingViewController,
            let booking = editBookingVC.booking
        else { return }
        
        self.booking = booking
        self.setupTableView(with: booking)
        delegate?.bookingDetailsViewController(self, didUpdateBooking: booking)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard
            segue.identifier == R.segue.bookingDetailsViewController.presentEditView.identifier,
            let navController = segue.destination as? UINavigationController,
            let editBookingVC = navController.children.first as? AddEditBookingViewController
        else {
            preconditionFailure("Couldn't perform segue to edit booking view")
        }
        
        editBookingVC.modelController = AddEditBookingModelController(booking: booking)
    }
}


// MARK: - UITableViewDelegate

extension BookingDetailsViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
    }
    
}


// MARK: - Private Helper Methods

private extension BookingDetailsViewController {

    func setupTableView(with booking: Booking) {
        setupBookingInfoCells(with: booking)
        setupBookingChargesCells(with: bookingChargesTableViewModel)
        
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
            checkOutDate: booking.checkOutDate,
            numberOfNights: booking.numberOfNights
        )
        
        roomImageCell.roomImage = booking.room.type.cellHeaderImage
        roomImageCell.roomTypeName = booking.room.type.name
    }

    
    func setupBookingChargesCells(with viewModel: BookingChargesTableViewModel) {
        numberOfNightsLabel.text = viewModel.numberOfNightsText
        roomTypeShortCodeLabel.text = viewModel.roomTypeText
        totalRoomPriceLabel.text = viewModel.totalRoomPriceText
        totalValetBotPriceLabel.text = viewModel.valetBotPriceText
        roomValetBotStatusLabel.text = viewModel.valetBotStatusText
        totalPriceLabel.text = viewModel.totalPriceText
    }
}
