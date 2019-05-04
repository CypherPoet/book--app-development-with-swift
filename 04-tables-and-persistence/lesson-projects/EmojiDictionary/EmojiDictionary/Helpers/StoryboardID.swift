//
//  StoryboardID.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum StoryboardID {
    enum ReuseIdentifier {
        static let emojiTableCell = "Emoji Table Cell"
    }
    
    enum Segue {
        static let addEmoji = "Add Emoji"
        static let editEmoji = "Edit Emoji"
        static let unwindFromSaveEmoji = "Unwind from Save Emoji"
    }
}

