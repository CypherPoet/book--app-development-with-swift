//
//  RoomType+SelectionOptions.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


extension RoomType {
    
    static var allOptions: [RoomType] {
        return [
            RoomType(
                id: "0",
                name: RoomType.Name.twoQueen,
                nameCode: RoomType.NameCode.twoQueen,
                price: RoomType.Satoshis.twoQueen
            ),
            RoomType(
                id: "1",
                name: RoomType.Name.oneKing,
                nameCode: RoomType.NameCode.oneKing,
                price: RoomType.Satoshis.oneKing
            ),
            RoomType(
                id: "2",
                name: RoomType.Name.suite,
                nameCode: RoomType.NameCode.suite,
                price: RoomType.Satoshis.suite
            ),
        ]
    }
}

