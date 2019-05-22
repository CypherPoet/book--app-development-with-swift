//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct StoreItem {
    var trackName: String?
    var description: String?
    var artistName: String
    var collectionName: String?
    var artworkURL: URL
    var genres: [String]?
    var primaryGenreName: String?
    var artworkImage: UIImage?
    var placeholderImage: UIImage?
}


extension StoreItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case trackName = "trackName"
        case description
        case artistName
        case collectionName
        case artworkURL = "artworkUrl100"
        case genres
        case primaryGenreName
    }
    
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)

        trackName = try? rootContainer.decode(String.self, forKey: .trackName)
        description = try? rootContainer.decode(String.self, forKey: .description)
        artistName = try rootContainer.decode(String.self, forKey: .artistName)
        collectionName = try? rootContainer.decode(String.self, forKey: .collectionName)
        artworkURL = try rootContainer.decode(URL.self, forKey: .artworkURL)
        genres = try? rootContainer.decode([String].self, forKey: .genres)
        primaryGenreName = try? rootContainer.decode(String.self, forKey: .primaryGenreName)
        
        artworkImage = nil
        placeholderImage = R.image.storeIconThumbnail()
    }
}
