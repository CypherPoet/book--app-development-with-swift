//
//  PhotoInfoModelController.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

struct PhotoInfoModelController {
    var photoInfoManager = DataLoader()
}

/**
 🤔 Is this extra layer necessary? Perhaps not with such a simple app -- but I'm
 kind of just experimenting with the architectural possibilities here 🙂.
 */
extension PhotoInfoModelController {
    
    func fetchInfo(
        from url: URL,
        then completionHandler: @escaping (PhotoInfo?) -> Void
    ) {
        photoInfoManager.fetch(PhotoInfo.self, from: url, with: PhotoInfo.defaultDecoder) { result in
            switch result {
            case .success(let photoInfo):
                completionHandler(photoInfo)
            case .failure(let error):
                print("Error while loading photo info:\n\n\(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
    
    
    func fetchPhotoImage(
        from url: URL,
        then completionHandler: @escaping (UIImage?) -> Void
    ) {
        photoInfoManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                completionHandler(UIImage(data: data))
            case .failure(let error):
                print("Error while loading image data:\n\n\(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
}
