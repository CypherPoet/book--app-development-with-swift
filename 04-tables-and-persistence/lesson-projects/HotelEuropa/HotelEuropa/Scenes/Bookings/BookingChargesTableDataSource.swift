//
//  BookingChargesTableDataSource.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingChargesTableDataSource: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Booking, UITableViewCell) -> Void
    
    var cellConfigurator: CellConfigurator
    var booking: Booking
    
    var cellTypeOrder: [CellType] = [
        .numberOfNights,
        .roomType,
        .valetBot,
        .totalPrice
    ]
    

    init(
        booking: Booking,
        cellConfigurator: @escaping CellConfigurator,
        cellTypeOrder: [CellType]? = nil
    ) {
        self.booking = booking
        self.cellConfigurator = cellConfigurator
        
        if let customCellTypeOrder = cellTypeOrder {
            self.cellTypeOrder = customCellTypeOrder
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypeOrder.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Charges"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypeOrder[indexPath.row]
        let reuseIdentifier = getReuseIdentifier(for: cellType)
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        ) as? BookingChargesTableViewCell else {
            preconditionFailure("Unable to dequeue booking charges table view cell")
        }
        
        cellConfigurator(booking, cell)
        
        return cell
    }
}


extension BookingChargesTableDataSource {
    
    enum CellType {
        case numberOfNights
        case roomType
        case valetBot
        case totalPrice
    }
}


extension BookingChargesTableDataSource {
    func getReuseIdentifier(for cellType: CellType) -> String {
        switch cellType {
        case .numberOfNights:
            return R.reuseIdentifier.bookingChargesNumberOfNights.identifier
        case .roomType:
            return R.reuseIdentifier.bookingChargesRoomType.identifier
        case .valetBot:
            return R.reuseIdentifier.booknigChargesValetBot.identifier
        case .totalPrice:
            return R.reuseIdentifier.bookingChargesTotalPrice.identifier
        }
    }
}
