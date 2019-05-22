//
//  CategoryMenuModelController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

final class CategoryMenuModelController {
    var category: MenuCategory
    
    lazy var apiClient = APIClient()
    
    
    init(category: MenuCategory) {
        self.category = category
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


extension CategoryMenuModelController {
    func loadMenuItems(
        then completionHandler: @escaping (Result<[MenuItem], Error>) -> Void
    ) {
        let menuItemsResource = APIResource<MenuItems>(from: menuItemsURL)
        
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
