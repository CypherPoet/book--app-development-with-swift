import Foundation

public struct StoreItem {
    public var kind: String
    public var artistName: String
    public var collectionName: String
    public var trackName: String
    public var artworkURL: URL
    public var genres: [String]
}


extension StoreItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case kind
        case artistName
        case collectionName
        case trackName
        case artworkURL = "artworkUrl100"
        case genres
    }
    
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        kind = try rootContainer.decode(String.self, forKey: .kind)
        artistName = try rootContainer.decode(String.self, forKey: .artistName)
        collectionName = try rootContainer.decode(String.self, forKey: .collectionName)
        trackName = try rootContainer.decode(String.self, forKey: .trackName)
        artworkURL = try rootContainer.decode(URL.self, forKey: .artworkURL)
        genres = try rootContainer.decode([String].self, forKey: .genres)
    }
}


public struct StoreItems {
    public var results: [StoreItem]
}

extension StoreItems: Codable {}
