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
    var usages: [String] = []
}


extension Emoji: Codable {}
