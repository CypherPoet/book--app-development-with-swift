import Foundation

extension FileManager {
    public static func documentsDirectory() -> URL {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
