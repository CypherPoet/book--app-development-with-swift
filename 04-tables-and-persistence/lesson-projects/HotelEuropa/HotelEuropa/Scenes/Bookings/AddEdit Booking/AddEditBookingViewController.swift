//
//  AddEditBookingViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class AddEditBookingViewController: UITableViewController {
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var checkInDateCell: UITableViewCell!
    @IBOutlet private weak var checkInDatePickerCell: UITableViewCell!
    @IBOutlet private weak var checkOutDateCell: UITableViewCell!
    @IBOutlet private weak var checkOutDatePickerCell: UITableViewCell!
    
    @IBOutlet private weak var checkInDateValueLabel: UILabel!
    @IBOutlet private weak var checkInDatePicker: UIDatePicker!
    @IBOutlet private weak var checkOutDateValueLabel: UILabel!
    @IBOutlet private weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet private weak var numberOfAdultsLabel: UILabel!
    @IBOutlet private weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    @IBOutlet private weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet private weak var valetBotSwitch: UISwitch!
    
    @IBOutlet private weak var selectedRoomTypeLabel: UILabel!
    
    @IBOutlet private weak var numberOfNightsLabel: UILabel!
    @IBOutlet private weak var roomTypeShortCodeLabel: UILabel!
    @IBOutlet private weak var totalRoomPriceLabel: UILabel!
    @IBOutlet private weak var roomValetBotStatusLabel: UILabel!
    @IBOutlet private weak var totalValetBotPriceLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var modelController: AddEditBookingModelController!
    var booking: Booking?
    var isNewBooking = false
    
    var selectedRoomType: RoomType? {
        didSet {
            selectedRoomTypeLabel.text = selectedRoomType?.name ?? "Not Set"
        }
    }

    private lazy var checkInDateIndexPath = IndexPath(row: 0, section: 1)
    private lazy var checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    
    private lazy var checkOutDateIndexPath = IndexPath(row: 2, section: 1)
    private lazy var checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    private lazy var visibleDatePickerHeight = CGFloat(212)
    
    private var isCheckInPickerVisible = false {
        didSet {
            tableView.beginUpdates()
            checkInDatePicker.isHidden = !isCheckInPickerVisible
            checkOutDatePicker.isHidden = isCheckInPickerVisible
            tableView.endUpdates()
        }
    }
    
    private var isCheckOutPickerVisible = false {
        didSet {
            tableView.beginUpdates()
            checkOutDatePicker.isHidden = !isCheckOutPickerVisible
            checkInDatePicker.isHidden = isCheckOutPickerVisible
            tableView.endUpdates()
        }
    }
}


// MARK: - Computed Properties

extension AddEditBookingViewController {
    
    var bookingChanges: AddEditBookingModelController.Changes {
        return (
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            emailAddress: emailTextField.text ?? "",
            checkInDate: checkInDatePicker.date,
            checkOutDate: checkOutDatePicker.date,
            numberOfAdults: Int(numberOfAdultsStepper.value),
            numberOfChildren: Int(numberOfChildrenStepper.value),
            hasValetBot: valetBotSwitch.isOn,
            roomChoice: selectedRoomType
        )
    }
    
    
    var chargesViewModel: BookingChargesTableViewModel {
        return BookingChargesTableViewModel(
            roomTypeCode: selectedRoomType?.nameCode,
            roomNightlyRate: selectedRoomType?.price,
            numberOfNights: numberOfNights,
            hasValetBot: valetBotSwitch.isOn,
            valetBotRate: Booking.valetBotRate
        )
    }
    
    
    var numberOfNights: Int {
        return checkInDatePicker.date.daysBetween(checkOutDatePicker.date)
    }
    
    
    var minimumCheckInDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    
    var minimumCheckOutDate: Date {
        let secondsInDay = 60 * 60 * 24
        
        return checkInDatePicker.date.addingTimeInterval(TimeInterval(secondsInDay))
    }
    
    
    var cancelSegueIdentifier: String {
        return isNewBooking ?
            R.segue.addEditBookingViewController.unwindFromCancelAdd.identifier :
            R.segue.addEditBookingViewController.unwindFromCancelEdit.identifier
    }
    
    
    var doneSegueIdentifier: String {
        return isNewBooking ?
            R.segue.addEditBookingViewController.unwindFromSaveAddBooking.identifier :
            R.segue.addEditBookingViewController.unwindFromSaveEditBooking.identifier
    }
}


// MARK: - Lifecycle

extension AddEditBookingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard modelController != nil else {
            preconditionFailure("Model controller not set")
        }
        
        booking = modelController.booking
        configureUI(with: booking)
    }
    
}


// MARK: - Event handling

extension AddEditBookingViewController {
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        updateChargesTable(with: chargesViewModel)
    }
    
    
    @IBAction func guestStepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuestsViews()
    }
    
    
    @IBAction func valetBotSwitchFlipped(_ sender: UISwitch) {
        updateChargesTable(with: chargesViewModel)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: cancelSegueIdentifier, sender: self)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        modelController.updateBooking(with: bookingChanges) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let booking):
                self.booking = booking
                print("Updated booking: \(booking)")
                self.performSegue(withIdentifier: self.doneSegueIdentifier, sender: self)
            case .failure(let error):
                self.display(alertMessage: error.localizedDescription, title: "Failed to save new registration")
            }
        }
    }
}


// MARK: - Navigation

extension AddEditBookingViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case R.segue.addEditBookingViewController.showRoomTypeSelectionView.identifier:
            handleSegueToRoomTypeSelection(segue)
        default:
            break
        }
    }
    
    
    func handleSegueToRoomTypeSelection(_ segue: UIStoryboardSegue) {
        guard
            let selectRoomTypeViewController = segue.destination as? SelectRoomTypeViewController
        else {
            return
        }
        
        selectRoomTypeViewController.delegate = self
        selectRoomTypeViewController.selectedRoomType = selectedRoomType
    }
    
}


// MARK: - UITableViewDelegate

extension AddEditBookingViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, indexPath.section) {
        case (checkInDatePickerIndexPath.row, checkInDatePickerIndexPath.section):
            return isCheckInPickerVisible ? visibleDatePickerHeight : 0.0
        case (checkOutDatePickerIndexPath.row, checkOutDatePickerIndexPath.section):
            return isCheckOutPickerVisible ? visibleDatePickerHeight : 0.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row, indexPath.section) {
        case (checkInDateIndexPath.row, checkInDateIndexPath.section):
            isCheckInPickerVisible.toggle()
            isCheckOutPickerVisible = false
        case (checkOutDateIndexPath.row, checkOutDateIndexPath.section):
            isCheckInPickerVisible = false
            isCheckOutPickerVisible.toggle()
        default:
            break
        }
    }
}


// MARK: - SelectRoomTypeTableViewControllerDelegate

extension AddEditBookingViewController: SelectRoomTypeViewControllerDelegate {
    
    func selectRoomTypeViewController(
        _ controller: SelectRoomTypeViewController,
        didSelectRoomType roomType: RoomType
    ) {
        selectedRoomType = roomType
        updateChargesTable(with: chargesViewModel)
    }
}


// MARK: - Private Helper Methods

private extension AddEditBookingViewController {
    
    /**
     📝 A View-Model-based approach might have us use the `booking` to
     initialize a view model, and then call this function with said view model 🤔.
     */
    func configureUI(with booking: Booking?) {
        firstNameTextField.text = booking?.guest.firstName
        lastNameTextField.text = booking?.guest.lastName
        emailTextField.text = booking?.guest.emailAddress
        
        checkInDatePicker.minimumDate = minimumCheckInDate
        checkInDatePicker.date = booking?.checkInDate ?? minimumCheckInDate
        
        numberOfAdultsStepper.value = Double(booking?.guest.numberOfAdults ?? 1)
        numberOfChildrenStepper.value = Double(booking?.guest.numberOfChildren ?? 0)
        
        valetBotSwitch.isOn = booking?.hasValetBot ?? false
        
        selectedRoomType = booking?.room.type
        
        updateDateViews()
        updateNumberOfGuestsViews()
        updateChargesTable(with: chargesViewModel)
    }
    
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = minimumCheckOutDate
        
        checkInDateValueLabel.text = checkInDatePicker.date.pickerDisplayFormat
        checkOutDateValueLabel.text = checkOutDatePicker.date.pickerDisplayFormat
    }

    
    func updateNumberOfGuestsViews() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    
    func updateChargesTable(with viewModel: BookingChargesTableViewModel) {
        numberOfNightsLabel.text = viewModel.numberOfNightsText
        roomTypeShortCodeLabel.text = viewModel.roomTypeText
        totalRoomPriceLabel.text = viewModel.totalRoomPriceText
        totalValetBotPriceLabel.text = viewModel.valetBotPriceText
        roomValetBotStatusLabel.text = viewModel.valetBotStatusText
        totalPriceLabel.text = viewModel.totalPriceText
    }
}


