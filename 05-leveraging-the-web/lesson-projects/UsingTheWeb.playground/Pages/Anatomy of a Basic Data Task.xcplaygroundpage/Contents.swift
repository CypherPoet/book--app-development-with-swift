import UIKit

let url = URL(string: "https://www.apple.com")!

/**
 The completion handler of a data task takes three arguments:
 
    1) `Data?`: The body of the response, or the data that we requested from the server.
 
    2) `URLResponse?`: Information about the response itself, including a status
        code and any header fields included in the response.
 
    3) `Error?`: Any error that might have occured while running the network request.
 */


let dataTask = URLSession.shared.dataTask(with: url) {
    (data: Data?, response: URLResponse?, error: Error?) in
    
    if let data = data {
        print(String(decoding: data, as: UTF8.self))
    }
}

dataTask.resume()
