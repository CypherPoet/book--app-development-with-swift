//
//  EmojiListViewModel.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


class EmojiListViewModel {
    var emojis: [Emoji] = []
}


// MARK: - Computed Properties

extension EmojiListViewModel {

    var emojiSections: [[Emoji]] {
        return Dictionary(grouping: emojis, by: { $0.category })
            .sorted { $0.key < $1.key }
            .map { $0.value }
    }
    
    var emojiSectionHeaderTitles: [String] {
        return emojiSections.map { $0.first?.category ?? "Misc" }
    }
}


