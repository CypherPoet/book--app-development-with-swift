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
    let name: RoomType.Name
    let nameCode: RoomType.NameCode
    var price: Int
    
    
    enum Name: String, Codable {
        case twoQueen = "Two Queen Beds"
        case oneKing = "One King Bed"
        case suite = "Suite"
    }
    
    enum NameCode: String, Codable {
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
