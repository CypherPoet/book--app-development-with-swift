//
//  APIResource.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct APIResource<T> {
    var urlRequest: URLRequest
    
    let parse: (Data) -> Result<T, Error>
    
    enum HTTPMethod {
        case get
        case post
        
        var name: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            }
        }
    }
}


extension APIResource where T: Decodable {
    
    init(at url: URL, decoder: JSONDecoder = JSONDecoder()) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = HTTPMethod.get.name
        
        self.parse = { data in
            return Result { try decoder.decode(T.self, from: data) }
        }
    }


    init(
        to url: URL,
        with payload: Data,
        method: HTTPMethod = .post,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.name
        
        switch method {
        case .post:
            self.urlRequest.httpBody = payload
        case .get:
            break
        }
        
        self.parse = { data in
            return Result { try decoder.decode(T.self, from: data) }
        }
    }
    
}


extension APIResource where T == UIImage? {
    
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        
        self.parse = { data in
            return .success(UIImage(data: data))
        }
    }
}
