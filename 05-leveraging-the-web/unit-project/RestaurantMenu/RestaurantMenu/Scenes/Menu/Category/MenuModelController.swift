//
//  CategoryMenuModelController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class MenuModelController {
    private lazy var apiClient = APIClient()

    private var itemsByID: [Int: MenuItem] = [:]
    private var itemsByCategoryName: [String: [MenuItem]] = [:]
    
    
    enum MenuModelControllerError: Error {
        case noData
    }
}


// MARK: - Computed Properties and Helpers

extension MenuModelController {
    
    private var menuItemsFileURL: URL {
        return FileManager
            .userDocumentsDirectory
            .appendingPathComponent("menu-items", isDirectory: false)
            .appendingPathExtension("json")
    }
    
    
    private var menuItemsAPIPath: URL {
        guard let url = URL(string: MenuItems.baseURL) else {
            preconditionFailure("Unable to make base MenuItems url")
        }
        
        return url
    }
    
    
    private func menuItemsAPIPath(for category: MenuCategory) -> URL {
        return menuItemsAPIPath.withQuery(params: [
            MenuItems.QueryParamName.category: category.name
        ])!
    }
}


// MARK: - Core Methods and Computeds

extension MenuModelController {
    
    func detailsViewModel(for menuItem: MenuItem) -> MenuItemDetailViewController.ViewModel {        
        return MenuItemDetailViewController.ViewModel(
            price: menuItem.price,
            itemName: menuItem.name,
            itemDescription: menuItem.details,
            headerImage: menuItem.fetchedImage
        )
    }
    
    
    func menuItems(for category: MenuCategory) -> [MenuItem] {
        return itemsByCategoryName[category.name] ?? [MenuItem]()
    }
    
    
    var categories: [MenuCategory] {
        let availableCategories = Array(itemsByCategoryName.keys).map { MenuCategory(name: $0) }
        
        return availableCategories.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    
    func persistMenuItems() {
        let menuItems = Array(itemsByID.values)
        
        do {
            let data = try JSONEncoder().encode(menuItems) as Data
            try data.write(to: menuItemsFileURL, options: [.atomic])
            print("Saved menu items data to \(menuItemsFileURL)")
        } catch {
            print("Error while saving data for menu items:\n\n\(error)")
        }
    }
    
    
    func loadPersistedMenuItems() {
        do {
            let data = try Data(contentsOf: menuItemsFileURL)
            let menuItems = try JSONDecoder().decode([MenuItem].self, from: data)
            print("Loaded local menu items from \(menuItemsFileURL)")
            
            menuItemsLoaded(menuItems)
        } catch {
            print("Error while loading local menu items from \(menuItemsFileURL):\n\n\(error)")
        }
    }
    
    
    func fetchRemoteData() {
        let menuItemsResource = APIResource<MenuItems>(at: menuItemsAPIPath)
        
        apiClient.sendRequest(for: menuItemsResource) { [weak self] result in
            switch result {
            case .success(let menuItems):
                self?.menuItemsLoaded(menuItems.items)
            case .failure(let error):
                print("Error while fetching remote menuItems data:\n\n\(error)")
            }
        }
    }
}



// MARK: - Private Helper Methods

private extension MenuModelController  {

    func menuItemsLoaded(_ menuItems: [MenuItem]) {
        itemsByID.removeAll(keepingCapacity: true)
        itemsByCategoryName.removeAll(keepingCapacity: true)
        
        for menuItem in menuItems {
            itemsByID[menuItem.id] = menuItem
            itemsByCategoryName[menuItem.categoryName, default: []].append(menuItem)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.defaultNotificationCenter.post(name: .MenuModelControllerDataUpdated, object: self)
        }
    }
}


extension MenuModelController: AppNotifiable {}
