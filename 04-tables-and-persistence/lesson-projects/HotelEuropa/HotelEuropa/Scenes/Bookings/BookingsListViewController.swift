//
//  BookingsListViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingsListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: TableViewDataSource<Booking>!
    private lazy var modelController = BookingsListModelController()
}


// MARK: - Lifecycle

extension BookingsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelController.start() { [weak self] bookings in
            DispatchQueue.main.async {
                self?.setupTableView(with: bookings)
            }
        }
    }
}


// MARK: - Navigation

extension BookingsListViewController {
    
    @IBAction func unwindFromCancelCreateBooking(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindFromSaveCreateBooking(unwindSegue: UIStoryboardSegue) {
        guard
            let createBookingVC = unwindSegue.source as? AddEditBookingViewController,
            let newBooking = createBookingVC.booking
        else {
            return assertionFailure("Performed unwindFromSaveCreateBooking segue without a newBooking")
        }
        
        newBookingAdded(newBooking)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case R.segue.bookingsListViewController.presentAddBookingView.identifier:
            segueToAddBooking(segue)
        case R.segue.bookingsListViewController.showBookingDetailsView.identifier:
            segueToBookingDetails(segue)
        default:
            return
        }
    }
}


// MARK: - BookingDetailsViewControllerDelegate

extension BookingsListViewController: BookingDetailsViewControllerDelegate {
    func bookingDetailsViewController(
        _ controller: BookingDetailsViewController,
        didUpdateBooking booking: Booking
    ) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else {
            preconditionFailure("Unable to find selected row for updated booking")
        }
        
        modelController.update(booking, at: selectedRow) { [weak self] (bookings) in
            self?.dataSource.models = bookings
            self?.tableView.reloadData()
        }
    }
}




// MARK: - Private Helper Methods

private extension BookingsListViewController {
    
    func setupTableView(with bookings: [Booking]) {
        setupBookingsDataSource(with: bookings)
    }

    
    func setupBookingsDataSource(with bookings: [Booking]) {
        let dataSource = TableViewDataSource(
            models: bookings,
            cellReuseIdentifier: R.reuseIdentifier.bookingCell.identifier,
            cellConfigurator: { (booking, cell) in
                guard let cell = cell as? BookingsListTableViewCell else {
                    preconditionFailure("Unable to dequeue BookingsListTableViewCell from table")
                }
                
                cell.viewModel = BookingCellViewModel(
                    guestFirstName: booking.guest.firstName,
                    guestLastName: booking.guest.lastName,
                    checkInDate: booking.checkInDate,
                    checkOutDate: booking.checkOutDate,
                    roomTypeName: booking.room.type.name
                )
            },
            cellDeletionHandler: { (booking, cell, indexPath) in
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.bookingDeleted(at: indexPath)
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    
    func newBookingAdded(_ newBooking: Booking) {
        modelController.add(newBooking) { [weak self] bookings in
            self?.dataSource.models = bookings
            self?.tableView.reloadData()
        }
    }
    
    
    func bookingDeleted(at indexPath: IndexPath) {
        modelController.deleteBooking(at: indexPath.row)
    }
    
    
    func segueToAddBooking(_ segue: UIStoryboardSegue) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let createBookingVC = navigationController.children.first as? AddEditBookingViewController
        else { return }
        
        createBookingVC.modelController = AddEditBookingModelController()
        createBookingVC.isNewBooking = true
    }
    
    
    func segueToBookingDetails(_ segue: UIStoryboardSegue) {
        guard
            let bookingDetailsVC = segue.destination as? BookingDetailsViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow
        else {
            preconditionFailure("Couldn't perform segue to booking details")
        }
        
        let selectedBooking = dataSource.models[selectedIndexPath.row]
        
        bookingDetailsVC.booking = selectedBooking
        bookingDetailsVC.delegate = self
    }
}
