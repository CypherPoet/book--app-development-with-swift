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
            .map {
                $0.value.sorted { (emoji1, emoji2) -> Bool in
                    return emoji1.name < emoji2.name
                }
            }
    }
    
    
    var emojiSectionHeaderTitles: [String] {
        return emojiSections.map { $0.first!.category }
    }
}


// MARK: - Core Methods

extension EmojiListViewModel {
    
    func sectionNumber(for emoji: Emoji) -> Int {
        guard let sectionNumber = emojiSectionHeaderTitles.firstIndex(of: emoji.category) else {
            preconditionFailure("Couldn't find emoji category \"\(emoji.category)\" in section titles")
        }
        
        return sectionNumber
    }
    
    
    func update(_ emoji: Emoji, at index: Int) {
        emojis[index] = emoji
    }
    
    
    func add(_ emoji: Emoji) -> (sectionAddedTo: Int, rowAddedAt: Int) {
        emojis.append(emoji)
        
        let sectionNumber = self.sectionNumber(for: emoji)
        let rowNumber = emojiSections[sectionNumber].lastIndex { $0.name == emoji.name }!
        
        return (sectionNumber, rowNumber)
    }
    
}


