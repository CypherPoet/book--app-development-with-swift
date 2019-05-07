//
//  EmojiManager.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class EmojiManager {
    typealias CompletionHandler = ([Emoji]) -> Void
    
    func loadDefaultEmojis(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping CompletionHandler
    ) {
        let dataURL = Endpoint.Emoji.initialData
        
        queue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let emojis = try self.decodeFrom(file: dataURL)

                completionHandler(emojis)

            } catch {
                print("Error while decoding emoji data:\n\n\(error.localizedDescription)")
            }
        }
    }
    
 
    func loadSavedEmojis(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping CompletionHandler
    ) {
        let dataURL = Endpoint.Emoji.savedData
        
        queue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let emojis = try self.decodeFrom(file: dataURL)
                
                completionHandler(emojis)
                
            } catch {
                print("Error while decoding emoji data:\n\n\(error.localizedDescription)")
            }
        }
    }
    
    
    func save(_ emojis: [Emoji]) {
        let dataURL = Endpoint.Emoji.savedData
        let encoder = JSONEncoder()
        
        do {
            let emojiData = try encoder.encode(emojis)
            print("Attempting to save emoji data at \"\(dataURL)\"")
            try emojiData.write(to: dataURL, options: [.noFileProtection, .atomic])
        } catch {
            print("Error while saving emoji data:\n\n\(error.localizedDescription)")
        }
    }
}



// MARK: - Private Helper Methods

private extension EmojiManager {
    
    func decodeFrom(file fileURL: URL) throws -> [Emoji] {
        if let data = try? Data(contentsOf: fileURL) {
            print("Emoji data found at url \"\(fileURL)\"")
            
            let decoder = JSONDecoder()
            
            return try decoder.decode([Emoji].self, from: data)
        } else {
            print("No emoji data found at url \"\(fileURL)\"")
            
            return [Emoji]()
        }
    }
    
}
