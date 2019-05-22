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


// MARK: - Encodable

extension Order: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case menuIds
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(menuItems.map { $0.id }, forKey: .menuIds)
    }
}


// MARK: - Transportable

extension Order: Transportable {
    static var baseURL = "http://localhost:8090/order"
}
