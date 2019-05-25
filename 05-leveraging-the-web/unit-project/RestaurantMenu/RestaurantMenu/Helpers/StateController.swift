//
//  StateController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class StateController {
    
    var currentOrder: Order = Order() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.defaultNotificationCenter.post(name: .StateControllerOrderUpdated, object: self)
            }
        }
    }
}


// MARK: - Computed Properties

extension StateController {
    
    var currentOrderFileURL: URL {
        return FileManager
            .userDocumentsDirectory
            .appendingPathComponent("current-order", isDirectory: false)
            .appendingPathExtension("json")
    }
}


// MARK: - Core Methods

extension StateController {
    
    func addItemToOrder(_ item: MenuItem) {
        currentOrder.menuItems.append(item)
    }
    
    func removeItemFromOrder(at index: Int) {
        currentOrder.menuItems.remove(at: index)
    }
    
    func clearOrder() {
        currentOrder.menuItems.removeAll(keepingCapacity: true)
    }
    
    
    func persistCurrentOrder() {
        do {
            let orderData = try JSONEncoder().encode(currentOrder) as Data
            try orderData.write(to: currentOrderFileURL, options: [.atomic])
            print("Saved current order data to \(currentOrderFileURL)")
        } catch {
            print("Error while saving data for current order:\n\n\(error)")
        }
    }
    
    
    func loadPersistedCurrentOrder() {
        do {
            let orderData = try Data(contentsOf: currentOrderFileURL)
            currentOrder = try JSONDecoder().decode(Order.self, from: orderData)
            print("Loaded saved order data from \(currentOrderFileURL)")
        } catch {
            print("Error while loading data for current order:\n\n\(error)")
        }
    }
}


extension StateController: AppNotifiable {}
