//
//  BookingsManager.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct BookingsManager {

    func loadSavedBookings(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping (Result<[Booking], Error>) -> Void
    ) {
        queue.async {
            do {
                guard let bookingsData = try? Data(contentsOf: self.savedDataURL) else {
                    print("No booking data found at \(self.savedDataURL)")
                    return completionHandler(.success([Booking]()))
                }
                
                let bookings = try self.decodeBookings(from: bookingsData)
                completionHandler(.success(bookings))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func save(_ bookings: [Booking]) {
        do {
            let encodedData = try encode(bookings)
            print("Attempting to save bookings to \(savedDataURL)")
            try encodedData.write(to: savedDataURL, options: [.atomic, .noFileProtection])
        } catch {
            print("Error while attempting to save bookings data to file:\n\n\(error.localizedDescription)")
        }
    }
}


// MARK: - Computed Properties

extension BookingsManager {
    var savedDataURL: URL {
        return FileManager
            .userDocumentsDirectory
            .appendingPathComponent("saved-bookings", isDirectory: false)
            .appendingPathExtension("json")
    }
}


// MARK: - Private Helper Methods

private extension BookingsManager {
    
    func decodeBookings(from data: Data) throws -> [Booking] {
        let decoder = Booking.defaultDecoder
        
        return try decoder.decode([Booking].self, from: data)
    }
    
    
    func encode(_ bookings: [Booking]) throws -> Data {
        let encoder = Booking.defaultEncoder
        
        return try encoder.encode(bookings)
    }
}
