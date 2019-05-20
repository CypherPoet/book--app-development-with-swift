//
//  URLSession+LoadAPIResource.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension URLSession {
    
    func load(
        with urlRequest: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
}
