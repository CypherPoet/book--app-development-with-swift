//
//  HeaderedTransport.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

final class HeaderedTransport: Transport {
    let baseTransport: Transport
    let headers: [String: String]
    

    init(baseTransport: Transport, headers: [String: String]) {
        self.baseTransport = baseTransport
        self.headers = headers
    }

    
    func send(request: URLRequest, then completionHandler: @escaping (Result<Data, Error>) -> Void) {
        var newRequest = request
        
        for (headerField, value) in headers {
            newRequest.addValue(value, forHTTPHeaderField: headerField)
        }
        
        baseTransport.send(request: newRequest, then: completionHandler)
    }
}
