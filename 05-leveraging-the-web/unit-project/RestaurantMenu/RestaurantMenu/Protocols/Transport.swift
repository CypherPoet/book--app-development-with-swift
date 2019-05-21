//
//  Transport.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

// A transport maps a URLRequest to Data, asynchronously
protocol Transport {
    func send(request: URLRequest, then completionHandler: @escaping (Result<Data, Error>) -> Void)
}
