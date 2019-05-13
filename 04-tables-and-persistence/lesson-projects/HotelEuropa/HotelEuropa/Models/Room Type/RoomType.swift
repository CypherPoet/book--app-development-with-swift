//
//  RoomType.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

struct RoomType {
    let id: String
    let name: String
    let nameCode: String
    var price: Int
    
    
    enum Name {
        static let twoQueen = "Two Queen Beds"
        static let oneKing = "One King Bed"
        static let suite = "Suite"
    }
    
    enum NameCode {
        static let twoQueen = "QQ"
        static let oneKing = "K"
        static let suite = "KK"
    }
    
    enum Satoshis {
        static let twoQueen = 50
        static let oneKing = 109
        static let suite = 150
    }
}


// MARK: - Computed Properties

extension RoomType {
    
    var cellHeaderImage: UIImage? {
        switch name {
        case Name.oneKing:
            return R.image.oneKingRoomHeader()
        case Name.suite:
            return R.image.suiteRoomHeader()
        case Name.twoQueen:
            return R.image.twoQueenRoomHeader()
        default:
            return R.image.europaHeader()
        }
    }
    
}



// MARK: - Equatable Conformance

extension RoomType: Equatable {

    static func == (lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
}


extension RoomType: Codable {}
