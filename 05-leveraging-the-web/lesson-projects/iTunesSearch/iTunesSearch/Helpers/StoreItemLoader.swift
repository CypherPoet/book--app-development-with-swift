//
//  StoreItemLoader.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct StoreItemLoader {
    
    static let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    enum QueryParamName {
        static let media = "media"
        static let entity = "entity"
        static let term = "term"
        static let country = "country"
        static let limit = "limit"
    }
    
    enum LoaderError: Error {
        case noData
    }
}


extension StoreItemLoader {
    
    func performSearch(
        for term: String,
        in mediaType: MediaType,
        withLimit limit: Int = 100,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping (Result<StoreItems, Error>) -> Void
    ) {
        let searchURL = makeURL(for: term, in: mediaType, withLimit: limit)
        let resource = APIResource<StoreItems>(get: searchURL)
        
        queue.async {
            URLSession.shared.load(with: resource.urlRequest) { dataResult in
                switch dataResult {
                case .success(let data):
                    completionHandler(resource.parseJSON(data))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    
    func makeURL(
        for term: String,
        in mediaType: MediaType,
        withLimit limit: Int = 100
    ) -> URL {
        let queryData: [String: String] = [
            QueryParamName.term: term,
            QueryParamName.media: mediaType.queryParamValue,
            QueryParamName.limit: "\(limit)",
            // TODO: More params?
        ]
        
        guard let url = StoreItemLoader.baseURL.withQueries(queryData) else {
            preconditionFailure("Failed to make url for term with queries")
        }
        
        return url
    }
}


