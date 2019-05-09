//
//  CreateBookingViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CreateBookingViewController: UITableViewController {
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var checkInDateValueLabel: UILabel!
    @IBOutlet private weak var checkInDatePicker: UIDatePicker!
    @IBOutlet private weak var checkOutDateValueLabel: UILabel!
    @IBOutlet private weak var checkOutDatePicker: UIDatePicker!
    
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var modelController: CreateBookingModelController!
    var booking: Booking?
}


// MARK: - Computed Properties

extension CreateBookingViewController {
    
    var bookingChanges: CreateBookingModelController.Changes {
        return (
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            emailAddress: emailTextField.text ?? ""
        )
    }
    
    var minimumCheckInDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    
    var minimumCheckOutDate: Date {
        let secondsInDay = 60 * 60 * 24
        
        return checkInDatePicker.date.addingTimeInterval(TimeInterval(secondsInDay))
    }
    
}


// MARK: - Lifecycle

extension CreateBookingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard modelController != nil else {
            preconditionFailure("Model controller not set")
        }
        
        checkInDatePicker.minimumDate = minimumCheckInDate
        checkInDatePicker.date = minimumCheckInDate
        updateDateViews()
    }
    
}


// MARK: - Event handling

extension CreateBookingViewController {
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        modelController.createBooking(with: bookingChanges) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let booking):
                print("Created booking: \(booking)")
                self.booking = booking
                self.performSegue(withIdentifier: R.segue.createBookingViewController.unwindFromSaveNewBooking, sender: self)
            case .failure(let error):
                self.display(alertMessage: error.localizedDescription, title: "Failed to save new registration")
            }
        }
    }
}


// MARK: - Private Helper Methods

private extension CreateBookingViewController {
    func updateDateViews() {
        checkOutDatePicker.minimumDate = minimumCheckOutDate
        
        checkInDateValueLabel.text = checkInDatePicker.date.pickerDisplayFormat
        checkOutDateValueLabel.text = checkOutDatePicker.date.pickerDisplayFormat
    }
}

