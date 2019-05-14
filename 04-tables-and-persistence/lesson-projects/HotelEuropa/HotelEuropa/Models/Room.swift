//
//  Room.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Room {
    let number: Int
    let type: RoomType
}

extension Room: Codable {}
