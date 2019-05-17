import Foundation

public struct PhotoInfo {
    public var title: String
    public var description: String
    public var url: URL
    public var copyright: String?
}


extension PhotoInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
    
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try rootContainer.decode(String.self, forKey: .title)
        description = try rootContainer.decode(String.self, forKey: .description)
        url = try rootContainer.decode(URL.self, forKey: .url)
        copyright = try? rootContainer.decode(String.self, forKey: .copyright)
    }
}
