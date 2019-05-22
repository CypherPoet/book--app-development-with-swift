//
//  MenuCategory.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct MenuCategory {
    var name: String
    
    
    enum CategoryName: String {
        case beverages
        case appetizers
        case salads
        case entrees
        case desserts
        case sandwiches
    }
    
    
    enum Error: Swift.Error {
        case UnknownCategory
    }
}


extension MenuCategory: Decodable {
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.singleValueContainer()
        let nameString = try valueContainer.decode(String.self)
        
        if let _ = CategoryName(rawValue: nameString) {
            self.name = nameString
        } else {
            throw Error.UnknownCategory
        }
    }
}
