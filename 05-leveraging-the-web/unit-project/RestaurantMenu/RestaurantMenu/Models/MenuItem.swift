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
    var categoryName: String
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
        case categoryName = "category"
    }
}


// MARK: - Core Methods

extension MenuItem {
    
    mutating func setFetchedImage(with dataResult: Result<Data, Error>) {
        switch dataResult {
        case .success(let imageData):
            if let image = UIImage(data: imageData) {
                fetchedImage = image
            } else {
                print("Failed to make image from data at url \"\(imageURL)\"")
                fetchedImage = placeholderImage
            }
        case .failure(let error):
            print("Error while attempting to fetch menu item image:\n\n\(error)")
            fetchedImage = placeholderImage
        }
    }
    
}
