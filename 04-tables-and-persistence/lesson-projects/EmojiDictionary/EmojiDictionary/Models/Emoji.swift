//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class Emoji {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    var category: String
    

    init(
        symbol: String,
        name: String,
        description: String,
        usage: String,
        category: String
    ) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
        self.category = category
    }
}


extension Emoji: Codable {}


extension Emoji {
    enum Category: String, CaseIterable {
        case smileysAndPeople = "Smileys & People"
        case animalsAndNature = "Animals & Nature"
        case foodAndDrink = "Food & Drink"
        case activity = "Activities"
        case travelAndPlaces = "Travel & Places"
        case objects = "Objects"
        case symbols = "Symbols"
        case flags = "Flags"
    }
}
