//
//  MenuItem.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

struct MenuItem {
    var id: Int
    var name: String
    var details: String
    var price: Int
    var imageURL: URL
    var category: String
    var placeholderImage: UIImage = #imageLiteral(resourceName: "placeholder")
    var fetchedImage: UIImage?
}


extension MenuItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case details = "description"
        case price
        case imageURL = "image_url"
        case category
    }
}
