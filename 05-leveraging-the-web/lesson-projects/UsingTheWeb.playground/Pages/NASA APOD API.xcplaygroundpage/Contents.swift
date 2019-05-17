//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = queries.map { (param, value) in
            return URLQueryItem(name: param, value: value)
        }
        
        return components?.url
    }
}


func performFetch(with url: URL, then completionHandler: @escaping (PhotoInfo?) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        
        if let error = error {
            fatalError("Error while making request: \(error.localizedDescription)" )
        }
        
        guard let data = data else {
            fatalError("No data in response")
        }
        
        completionHandler(decodePhotoInfo(from: data))
        PlaygroundPage.current.finishExecution()
    }
    
    dataTask.resume()
}


func decodePhotoInfo(from data: Data) -> PhotoInfo? {
    let decoder = JSONDecoder()
    
    do {
        return try decoder.decode(PhotoInfo.self, from: data)
    } catch {
        print("Error while trying to decode photoInfo:\n\n\(error.localizedDescription)")
    }
        
    return nil
}


let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!

let fullURL = baseURL.withQueries([
    "hd": "true",
    "api_key": "DEMO_KEY",
    "date": "2018-01-08"
])



performFetch(with: fullURL!) { photoInfo in
    guard let photoInfo = photoInfo else {
        return print("No photo info found")
    }
    
    print(photoInfo.description)
}

//: [Next](@next)
