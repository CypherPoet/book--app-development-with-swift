//
//  URL+WithQuery.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension URL {
    
    func withQuery(params: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = params.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        return components?.url
    }
    
}
