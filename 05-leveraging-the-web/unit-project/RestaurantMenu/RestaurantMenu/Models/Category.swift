//
//  Category.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Category {
    var name: String
}


extension Category: Codable {
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.singleValueContainer()
 
        name = try valueContainer.decode(String.self)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(name)
    }
}
