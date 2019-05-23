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
            NotificationCenter.default.post(name: .StateControllerOrderUpdated, object: self)
        }
    }
}


extension StateController {
    
    func addItemToOrder(_ item: MenuItem) {
        currentOrder.menuItems.append(item)
    }
    
    func removeItemFromOrder(at index: Int) {
        currentOrder.menuItems.remove(at: index)
    }
}
