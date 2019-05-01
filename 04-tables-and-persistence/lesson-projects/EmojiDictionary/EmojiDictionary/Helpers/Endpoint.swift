//
//  Endpoint.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum Endpoint {
    
    enum Emoji {
    
        static var url: URL {
            guard let url = Bundle.main.url(forResource: "emoji-data", withExtension: "json") else {
                preconditionFailure("Failed to find URL to emoji data")
            }
            
            return url
        }
        
    }
    
}
