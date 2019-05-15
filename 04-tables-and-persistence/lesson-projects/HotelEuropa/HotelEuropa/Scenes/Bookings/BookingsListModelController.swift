//
//  BookingsListModelController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


class BookingsListModelController {
    private var bookings: [Booking] = []
    private var bookingsManager: BookingsManager
    
    typealias CompletionHandler = ([Booking]) -> Void
    
    init(bookingsManager: BookingsManager = .init()) {
        self.bookingsManager = bookingsManager
    }
}


extension BookingsListModelController {
    
    func start(then completionHandler: @escaping CompletionHandler) {
        bookingsManager.loadSavedBookings { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let bookings):
                self.bookings = bookings
                completionHandler(bookings)
            case .failure(let error):
                print("Error while loading bookings:\n\n\(error.localizedDescription)")
                completionHandler([Booking]())
            }
        }
    }
    
    
    func add(
        _ booking: Booking,
        at index: Int? = nil,
        then completionHandler: CompletionHandler? = nil
    ) {
        let index = index ?? bookings.count

        bookings.insert(booking, at: index)
        bookingsManager.save(bookings)
        
        completionHandler?(bookings)
    }
    
    
    func update(
        _ booking: Booking,
        at index: Int,
        then completionHandler: CompletionHandler? = nil
    ) {
        bookings[index] = booking
        bookingsManager.save(bookings)
        
        completionHandler?(bookings)
    }
    
    
    
    func deleteBooking(
        at index: Int,
        then completionHandler: CompletionHandler? = nil
    ) {
        bookings.remove(at: index)
        bookingsManager.save(bookings)
        
        completionHandler?(bookings)
    }
}
