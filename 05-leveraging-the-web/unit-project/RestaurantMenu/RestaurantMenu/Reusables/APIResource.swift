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
    
    let decode: (Data) -> Result<T, Error>
}


extension APIResource where T: Decodable {
    
    init(get url: URL, using decoder: JSONDecoder = JSONDecoder()) {
        self.urlRequest = URLRequest(url: url)
        
        self.decode = { data in
            return Result { try decoder.decode(T.self, from: data) }
        }
    }
}


extension APIResource where T == UIImage? {
    
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        
        self.decode = { data in
            return .success(UIImage(data: data))
        }
    }
}
