//
//  RoomType.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct RoomType {
    let id: String
    let name: String
    let shortName: RoomType.RoomTypeCode
    var price: Int
    
    enum RoomTypeCode: String, Codable {
        case twoQueen = "QQ"
        case oneKing = "K"
        case suite = "KK"
    }
}



// MARK: - Equatable Conformance

extension RoomType: Equatable {

    static func == (lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
}
