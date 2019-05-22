//
//  APIClient.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class APIClient {
    let transport: Transport
    
    init(transport: Transport = URLSession.shared) {
        self.transport = transport
    }
}


extension APIClient {
    
    func sendRequest<Model>(
        for resource: APIResource<Model>,
        then completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        transport.send(request: resource.urlRequest) { dataResult in
            switch dataResult {
            case .success(let data):
                completionHandler(resource.parse(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
