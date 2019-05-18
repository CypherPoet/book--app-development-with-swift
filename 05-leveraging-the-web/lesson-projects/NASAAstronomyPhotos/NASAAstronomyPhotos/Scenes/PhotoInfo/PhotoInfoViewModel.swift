//
//  PhotoInfoViewModel.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct PhotoInfoViewModel {
    var title: String
    var description: String
    var copyright: String?
    var photoImage: UIImage?
    

    init(
        title: String,
        description: String,
        copyright: String?,
        photoImage: UIImage? = nil
    ) {
        self.title = title
        self.description = description
        self.copyright = copyright
        self.photoImage = photoImage
    }
}


// MARK: - Computed Properties

extension PhotoInfoViewModel {

    var copyrightText: String {
        if let copyright = copyright {
            return "Copyright \(copyright)"
        }
        
        return ""
    }
}

