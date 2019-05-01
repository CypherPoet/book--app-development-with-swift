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
            
            completionHandler(emojis)
        }
    }
}
