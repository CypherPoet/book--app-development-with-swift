//
//  PreparationTime.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct PreparationTime {
    var minutes: Int
}


extension PreparationTime: Codable {
    
    enum CodingKeys: String, CodingKey {
        case minutes = "preparation_time"
    }
    
}
