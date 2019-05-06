//
//  EmojiManager.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class EmojiManager {
    func load(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        completionHandler: @escaping ([Emoji]) -> Void
    ) {
        let dataURL = Endpoint.Emoji.initialData
        
        queue.async {
            do {
                let emojiData = try! Data(contentsOf: dataURL)
                let decoder = JSONDecoder()
                let emojis = try decoder.decode([Emoji].self, from: emojiData)

                completionHandler(emojis)

            } catch {
                print("Error while decoding emoji data:\n\n\(error.localizedDescription)")
            }
        }
    }
}
