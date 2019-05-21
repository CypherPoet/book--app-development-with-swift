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

extension Order: Codable {}
