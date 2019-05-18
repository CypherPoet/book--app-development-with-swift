//
//  PhotoInfoManager.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


final class DataLoader {
    static let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    let urlSession = URLSession.shared
    
    
    enum QueryParamName {
        static let apiKey = "api_key"
        static let date = "date"
        static let hd = "hd"
    }
    
    enum LoaderError: Error {
        case noData
    }
}


extension DataLoader {
    
    func fetchData(
        from url: URL,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {

        let dataTask = self.urlSession.dataTask(
            with: url,
            completionHandler: {
                (data, response, error) in
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                if let error = error {
                    completionHandler(.failure(error))
                }
                
                guard let data = data else {
                    completionHandler(.failure(LoaderError.noData))
                    return
                }
                
                completionHandler(.success(data))
            }
        )
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        queue.async {
            dataTask.resume()
        }
    }
    
    
    func fetch<Model: Decodable>(
        _ modelType: Model.Type,
        from url: URL,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        with decoder: JSONDecoder = JSONDecoder(),
        then completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        fetchData(from: url, on: queue) { result in
            switch result {
            case .success(let data):
                do {
                    let model = try decoder.decode(modelType, from: data)
                    
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
