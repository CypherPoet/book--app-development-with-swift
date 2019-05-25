//
//  CategoryMenuModelController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class MenuModelController {
    lazy var apiClient = APIClient()
}


// MARK: - Computed Properties

extension MenuModelController {
    
    func menuItemsURL(for category: MenuCategory) -> URL {
        guard let baseURL = URL(string: MenuItems.baseURL) else {
            preconditionFailure("Unable to make url")
        }
        
        return baseURL.withQuery(params: [
            MenuItems.QueryParamName.category: category.name
        ])!
    }
}


// MARK: - Core Methods

extension MenuModelController {
    
    func loadMenuItems(
        for category: MenuCategory,
        then completionHandler: @escaping (Result<[MenuItem], Error>) -> Void
    ) {
        let menuItemsResource = APIResource<MenuItems>(at: menuItemsURL(for: category))
        
        apiClient.sendRequest(for: menuItemsResource) { result in
            switch result {
            case .success(let menuItems):
                completionHandler(.success(menuItems.items))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
