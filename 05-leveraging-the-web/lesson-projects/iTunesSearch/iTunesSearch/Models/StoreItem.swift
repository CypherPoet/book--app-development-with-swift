//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct StoreItem {
    var name: String
    var description: String?
    var kind: String
    var artistName: String
    var collectionName: String?
    var artworkURL: URL
    var genres: [String]
}


extension StoreItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case description
        case kind
        case artistName
        case collectionName
        case artworkURL = "artworkUrl100"
        case genres
    }
    
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)

        name = try rootContainer.decode(String.self, forKey: .name)
        description = try? rootContainer.decode(String.self, forKey: .description)
        kind = try rootContainer.decode(String.self, forKey: .kind)
        artistName = try rootContainer.decode(String.self, forKey: .artistName)
        collectionName = try? rootContainer.decode(String.self, forKey: .collectionName)
        artworkURL = try rootContainer.decode(URL.self, forKey: .artworkURL)
        genres = try rootContainer.decode([String].self, forKey: .genres)
    }
}
