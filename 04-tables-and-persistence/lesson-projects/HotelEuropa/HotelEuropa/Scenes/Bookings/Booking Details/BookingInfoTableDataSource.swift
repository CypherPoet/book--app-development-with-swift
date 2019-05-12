//
//  BookingInfoTableDataSource.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class BookingInfoTableDataSource: NSObject, UITableViewDataSource {
    var booking: Booking
    
    
    init(booking: Booking) {
        self.booking = booking
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return BookingRoomImageTableViewCell()
        case 1:
            return BookingDatesTableViewCell()
        case 2:
            return BookingRoomImageTableViewCell()
        default:
            fatalError("Unexpected IndexPath row")
        }
    }
}
