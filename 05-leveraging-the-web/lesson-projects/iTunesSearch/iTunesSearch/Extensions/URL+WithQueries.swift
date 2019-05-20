//
//  URL+WithQueries.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ params: [String: String]) -> URL? {
        var components = self.components
        
        components?.queryItems = params.map { (param, value) in
            return URLQueryItem(name: param, value: value)
        }
        
        return components?.url
    }
    
    
    func withHTTPS() -> URL? {
        var components = self.components
        
        components?.scheme = "https"
        
        return components?.url
    }
}


fileprivate extension URL {
    var components: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)
    }
}
