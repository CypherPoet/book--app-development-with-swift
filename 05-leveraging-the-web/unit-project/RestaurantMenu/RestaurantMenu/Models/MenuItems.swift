//
//  MenuItems.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct MenuItems {
    var items: [MenuItem]
    
    enum QueryParamName {
        static let category = "category"
    }
}

extension MenuItems: Decodable {}


// MARK: - Transportable

extension MenuItems: Transportable {
    static var baseURL = "http://localhost:8090/menu"
}
