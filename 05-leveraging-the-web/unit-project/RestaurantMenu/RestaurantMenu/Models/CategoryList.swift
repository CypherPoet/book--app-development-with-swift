//
//  Categories.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct CategoryList {
    var categories: [MenuCategory]
}

extension CategoryList: Decodable {}


// MARK: - API properties

extension CategoryList: Transportable {
    static var baseURL = "http://localhost:8090/categories"
}
