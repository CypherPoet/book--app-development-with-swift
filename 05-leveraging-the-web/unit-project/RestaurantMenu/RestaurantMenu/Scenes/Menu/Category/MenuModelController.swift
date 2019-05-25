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

    private var availableCategories: [MenuCategory] = []
    private var itemsByID: [Int: MenuItem] = [:]
    private var itemsByCategoryName: [String: [MenuItem]] = [:]
    
    
    enum MenuModelControllerError: Error {
        case noData
    }
}


// MARK: - Computed Properties and Helpers

extension MenuModelController {
    
    func menuItemsURL(for category: MenuCategory) -> URL {
        guard let baseURL = URL(string: MenuItems.baseURL) else {
            preconditionFailure("Unable to make url")
        }
        
        return baseURL.withQuery(params: [
            MenuItems.QueryParamName.category: category.name
        ])!
    }
    
    
    func detailsViewModel(forMenuId id: Int) -> MenuItemDetailViewController.ViewModel {
        guard let menuItem = itemsByID[id] else {
            preconditionFailure("No menu item found for id \"\(id)\"")
        }
        
        return MenuItemDetailViewController.ViewModel(
            price: menuItem.price,
            itemName: menuItem.name,
            itemDescription: menuItem.details,
            headerImage: menuItem.fetchedImage
        )
    }
    
    
    func menuItems(for category: MenuCategory) -> Result<[MenuItem], Error> {
        guard let menuItems = itemsByCategoryName[category.name] else {
            return .failure(MenuModelControllerError.noData)
        }
        
        return .success(menuItems)
    }
    
    
    var categories: [MenuCategory] {
        return availableCategories.sorted { $0.name.lowercased() < $1.name.lowercased() }
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
