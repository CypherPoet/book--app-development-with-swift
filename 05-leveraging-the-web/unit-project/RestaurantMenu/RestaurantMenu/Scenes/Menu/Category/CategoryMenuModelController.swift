//
//  CategoryMenuModelController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class CategoryMenuModelController {
    var category: MenuCategory
    
    lazy var apiClient = APIClient()
    
    
    init(category: MenuCategory) {
        self.category = category
    }
    
    enum ImageError: Error {
        case badData(String)
    }
}


// MARK: - Computed Properties

extension CategoryMenuModelController {
    
    var menuItemsURL: URL {
        guard let baseURL = URL(string: MenuItems.baseURL) else {
            preconditionFailure("Unable to make url")
        }
        
        return baseURL.withQuery(params: [
            MenuItems.QueryParamName.category: category.name
        ])!
    }
    
}


// MARK: - Core Methods

extension CategoryMenuModelController {
    
    func loadMenuItems(
        then completionHandler: @escaping (Result<[MenuItem], Error>) -> Void
    ) {
        let menuItemsResource = APIResource<MenuItems>(at: menuItemsURL)
        
        apiClient.sendRequest(for: menuItemsResource) { result in
            switch result {
            case .success(let menuItems):
                completionHandler(.success(menuItems.items))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func fetchImage(
        for menuItem: MenuItem,
        then completionHandler: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let urlRequest = URLRequest(url: menuItem.imageURL)
        
        URLSession.shared.send(request: urlRequest) { dataResult in
            switch dataResult {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    completionHandler(.success(image))
                } else {
                    completionHandler(.failure(
                        ImageError.badData(
                            "Failed to make image from data at url \"\(menuItem.imageURL)\""
                        )
                    ))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
