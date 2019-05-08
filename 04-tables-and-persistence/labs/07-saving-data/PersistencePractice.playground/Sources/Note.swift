import Foundation

public struct Note {
    let title: String
    let text: String
    let timestamp: Date
    
    
    public init(
        title: String,
        text: String,
        timestamp: Date
    ) {
        self.title = title
        self.text = text
        self.timestamp = timestamp
    }
}

extension Note: Codable {}
