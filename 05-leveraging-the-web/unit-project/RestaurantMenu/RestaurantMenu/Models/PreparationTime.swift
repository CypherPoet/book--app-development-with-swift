//
//  PreparationTime.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct PreparationTime {
    var seconds: Double
}


extension PreparationTime: Codable {
    
    enum CodingKeys: String, CodingKey {
        case seconds = "preparation_time"
    }
    
}
