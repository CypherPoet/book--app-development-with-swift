//
//  Order.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Order {
    var menuItems: [MenuItem] = []
}


// MARK: - Codable

extension Order: Codable {}


// MARK: - Transportable

extension Order: Transportable {
    static var baseURL = "http://localhost:8090/order"
}


// MARK: - Computed Properties

extension Order {
    
    var totalPrice: Int {
        return menuItems.reduce(0, { (accumulatedPrice, currentItem) -> Int in
            return accumulatedPrice + currentItem.price
        })
    }
    
    
    var menuIds: [Int] {
        return menuItems.map { $0.id }
    }
    
    
    var asPostableMenuData: [String: [Int]] {
        return ["menuIds": menuIds]
    }
}
