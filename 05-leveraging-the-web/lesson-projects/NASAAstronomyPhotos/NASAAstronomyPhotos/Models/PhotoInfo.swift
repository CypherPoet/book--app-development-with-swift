//
//  PhotoInfo.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct PhotoInfo {
    var title: String
    var description: String
    var url: URL
    var mediaType: String
    var copyright: String?
}


extension PhotoInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case mediaType
        case copyright
    }
    
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try rootContainer.decode(String.self, forKey: .title)
        description = try rootContainer.decode(String.self, forKey: .description)
        url = try rootContainer.decode(URL.self, forKey: .url)
        mediaType = try rootContainer.decode(String.self, forKey: .mediaType)
        copyright = try? rootContainer.decode(String.self, forKey: .copyright)
    }
}


extension PhotoInfo {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}
