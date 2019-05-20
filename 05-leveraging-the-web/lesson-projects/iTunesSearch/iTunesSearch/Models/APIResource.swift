//
//  APIResource.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct APIResource<T> {
    var urlRequest: URLRequest
    
    let parseJSON: (Data) -> Result<T, Error>
}


extension APIResource where T: Decodable {
    init(
        get url: URL,
        using decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlRequest = URLRequest(url: url)
        
        self.parseJSON = { data in
            return Result { try decoder.decode(T.self, from: data) }
        }
    }
}
