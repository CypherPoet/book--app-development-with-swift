//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Emoji {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    var category: String
}


extension Emoji: Codable {}


extension Emoji {
    enum Category {
        static let smileysAndPeople = "Smileys & People"
        static let animalsAndNature = "Animals & Nature"
        static let foodAndDrink = "Food & Drink"
        static let activity = "Activities"
        static let travelAndPlaces = "Travel & Places"
        static let objects = "Objects"
        static let symbols = "Symbols"
        static let flags = "Flags"
    }
}
