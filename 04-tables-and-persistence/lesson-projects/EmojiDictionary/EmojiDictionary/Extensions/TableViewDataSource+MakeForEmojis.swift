//
//  TableViewDataSource+MakeForEmojis.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


/**
 📝 Note for reference and learning...
 
 Attempting to implement Objective-C overrides here doesn't appear to work -- they don't get called.
 
 I think it's because Objective-C doesn't even see it -- that is, Objective-C doesn't see
 Swift generics: https://stackoverflow.com/a/39297511/8859365.
 */


extension TableViewDataSource where Model == Emoji {
    static func make(for emojis: [Emoji]) -> TableViewDataSource<Emoji> {
         return TableViewDataSource(
            models: emojis,
            cellReuseIdentifier: StoryboardID.ReuseIdentifier.emojiTableCell,
            cellConfigurator: { (emoji, cell) in
                guard let emojiCell = cell as? EmojiTableViewCell else {
                    preconditionFailure("Unknown cell returned for table view configuration: \(cell)")
                }
                
                emojiCell.configure(with: EmojiTableCellViewModel(
                    symbol: emoji.symbol,
                    name: emoji.name,
                    description: emoji.description
                ))
            },
            modelDeleter: { (model, indexPath) in
                
            }
        )
    }
}
