//
//  MainViewController.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class PhotoInfoViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoCopyrightLabel: UILabel!
    
    enum LoadingState {
        case inactive
        case loading
        case finished
    }
    
    lazy var modelController = PhotoInfoModelController()
    lazy var loadingViewController = LoadingViewController()
    
    var photoInfoViewModel: PhotoInfoViewModel? {
        didSet {
            guard
                let viewModel = photoInfoViewModel,
                let viewModelImage = viewModel.photoImage
            else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.photoImageView.image = viewModelImage
                self.title = viewModel.title
                self.descriptionTextView.text = viewModel.description
                
                if !viewModel.copyrightText.isEmpty {
                    self.photoCopyrightLabel.isHidden = false
                    self.photoCopyrightLabel.text = viewModel.copyrightText
                } else {
                    self.photoCopyrightLabel.isHidden = true
                }
            }
        }
    }
    
    var currentLoadingState: LoadingState = .inactive {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingStateChanged()
            }
        }
    }
}



// MARK: - Computed Properties

extension PhotoInfoViewController {
    
    var photoInfoURL: URL {
        let queryParams = [
            DataLoader.QueryParamName.apiKey: "DEMO_KEY",
            DataLoader.QueryParamName.date: "2019-05-16",
        ]
        
        guard let url = DataLoader.baseURL.withQueries(queryParams) else {
            preconditionFailure("Unable to form url for photoInfo")
        }
        
        return url
    }
}


// MARK: - Lifecycle

extension PhotoInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = ""
        
        loadPhotoInfo()
    }
}


// MARK: - Private Helper Methods

private extension PhotoInfoViewController {
    
    func loadPhotoInfo() {
        currentLoadingState = .loading
        
        modelController.fetchInfo(from: photoInfoURL) { [weak self] (photoInfo) in
            guard let self = self else { return }
            
            guard let photoInfo = photoInfo else {
                DispatchQueue.main.async {
                    self.display(alertMessage: "No photo info found while fetching from \(self.photoInfoURL)")
                }
                return
            }

            self.photoInfoViewModel = PhotoInfoViewModel(
                title: photoInfo.title,
                description: photoInfo.description,
                copyright: photoInfo.copyright
            )
            
            self.loadPhotoImage(from: photoInfo.url)
        }
    }
    
    
    func loadPhotoImage(from url: URL) {
        modelController.fetchPhotoImage(from: url) { [weak self] (image) in
            self?.photoInfoViewModel?.photoImage = image
            self?.currentLoadingState = .finished
        }
    }
    
    
    func loadingStateChanged() {
        switch currentLoadingState {
        case .loading:
            add(child: loadingViewController)
        case .finished:
            loadingViewController.performRemoval()
        default:
            break
        }
    }
}
