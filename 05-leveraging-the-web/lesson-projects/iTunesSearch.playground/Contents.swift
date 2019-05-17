import UIKit
import PlaygroundSupport

let page = PlaygroundPage.current

page.needsIndefiniteExecution = true


extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = queries.map { (param, value) in
            return URLQueryItem(name: param, value: value)
        }
        
        return components?.url
    }
    
}


func performFetch(with url: URL, then completionHandler: @escaping ([StoreItem]?) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            fatalError("Error while performing fetch: \(error.localizedDescription)")
        }
        
        guard let data = data else {
            fatalError("No data found in fetch to \(url)")
        }
        
//        print(String(decoding: data, as: UTF8.self))
        completionHandler(decodeStoreItem(from: data))
        
        page.finishExecution()
    }
    
    dataTask.resume()
}


func decodeStoreItem(from data: Data) -> [StoreItem]? {
    let decoder = JSONDecoder()
    
    do {
        let storeItems = try decoder.decode(StoreItems.self, from: data)
        
        return storeItems.results
    } catch {
        print("Error while decoding StoreItem data:\n\n\(error.localizedDescription)")
    }
    
    return nil
}


let baseURL = URL(string: "https://itunes.apple.com/search")!

let fullURL = baseURL.withQueries([
    "term": "Stephan Livera",
    "media": "podcast"
])


performFetch(with: fullURL!) { storeItems in
    guard
        let storeItems = storeItems,
        let firstItem = storeItems.first
    else {
        preconditionFailure("Failed to fetch store item data")
    }
    
    print(firstItem.artistName)
    print(firstItem.artworkURL)
    
    firstItem.artworkURL
}
