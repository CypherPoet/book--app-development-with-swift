//
//  EmojiListModelController.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class EmojiListModelController {
    var emojiManager: EmojiManager
    var viewModel: EmojiListViewModel
    

    init(
        emojiManager: EmojiManager = EmojiManager(),
        viewModel: EmojiListViewModel = EmojiListViewModel()
    ) {
        self.emojiManager = emojiManager
        self.viewModel = viewModel
    }
    
    
    func start(completionHandler: @escaping ([Emoji]) -> Void) {
        emojiManager.load { [weak self] (emojis) in
            self?.viewModel.emojis = emojis
            
            completionHandler(emojis)
        }
    }
    
    
    func add(_ emoji: Emoji, then completionHandler: @escaping ((sectionAddedTo: Int, rowAddedAt: Int)) -> Void) {
        // 📝 Normally, we'd probably make some kind of networking call here -- or at least something
        // to a manager that handled persistence (?)/
        let (sectionAddedTo, rowAddedAt) = viewModel.add(emoji)
        
        completionHandler((sectionAddedTo, rowAddedAt))
    }
    
    
    func update(_ emoji: Emoji, at index: Int, then completionHandler: @escaping () -> Void) {
        viewModel.update(emoji, at: index)
        
        completionHandler()
    }
}
