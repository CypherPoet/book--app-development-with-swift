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
    var emojiManager: EmojiManager

    
    init(emojiManager: EmojiManager = EmojiManager()) {
        self.emojiManager = emojiManager
    }
}


// MARK: - Computed Properties

extension EmojiListViewModel {

    var sectionedEmojis: [[Emoji]] {
        return Dictionary(grouping: emojis, by: { $0.category })
            .sorted { $0.key < $1.key }
            .map {
                $0.value.sorted { (emoji1, emoji2) -> Bool in
                    return emoji1.name < emoji2.name
                }
            }
    }
    
    
    var emojiSectionHeaderTitles: [String] {
        return sectionedEmojis.map { $0.first!.category }
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
    
    
    func start(then completionHandler: @escaping ([Emoji]) -> Void) {
        emojiManager.loadSavedEmojis { [weak self] (emojis) in
            guard let self = self else { return }
            
            if emojis.isEmpty {
                self.emojiManager.loadDefaultEmojis { (emojis) in
                    self.emojis = emojis
                    self.save() {
                        completionHandler(emojis)
                    }
                }
            } else {
                self.emojis = emojis
                completionHandler(emojis)
            }
        }
    }
    
    
    func update(_ emoji: Emoji, at index: Int, then completionHandler: @escaping () -> Void) {
        var currentEmojiList = sectionedEmojis.flatMap { $0 }
        
        currentEmojiList[index] = emoji
        emojis = currentEmojiList
        
        save {
            completionHandler()
        }
    }
    
    
    func delete(_ deletedEmoji: Emoji, at index: Int) {
        var currentEmojiList = sectionedEmojis.flatMap { $0 }
        
        currentEmojiList.remove(at: index)
        emojis = currentEmojiList
        
        save()
    }
    
    
    func add(_ emoji: Emoji, then completionHandler: @escaping ((sectionAddedTo: Int, rowAddedAt: Int)) -> Void) {
        emojis.append(emoji)
        
        let sectionAddedTo = self.sectionNumber(for: emoji)
        let rowAddedAt = sectionedEmojis[sectionAddedTo].lastIndex { $0.name == emoji.name }!
        
        save {
            return completionHandler((sectionAddedTo, rowAddedAt))
        }
    }
    
    
    func save(then completionHandler: (() -> Void)? = nil) {
        emojiManager.save(emojis)
        completionHandler?()
    }
    
}


