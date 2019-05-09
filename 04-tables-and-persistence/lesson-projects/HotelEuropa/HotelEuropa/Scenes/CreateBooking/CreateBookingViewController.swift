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
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var modelController: CreateBookingModelController!
    var booking: Booking?
}


// MARK: - Computed Properties

extension CreateBookingViewController {
    
    var bookingChanges: CreateBookingModelController.Changes {
        return (
            firstName: "",
            lastName: "",
            emailAddress: ""
        )
    }
}



// MARK: - Lifecycle

extension CreateBookingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard modelController != nil else {
            preconditionFailure("Model controller not set")
        }
    }
}


// MARK: - Event handling

extension CreateBookingViewController {
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        modelController.createBooking(with: bookingChanges) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let booking):
                print("Created booking: \(booking)")
//                self.booking = booking
                self.performSegue(withIdentifier: "Unwind From Save New Booking", sender: self)
            case .failure(let error):
                self.display(alertMessage: error.localizedDescription, title: "Failed to save new registration")
            }
        }
    }
    
}

