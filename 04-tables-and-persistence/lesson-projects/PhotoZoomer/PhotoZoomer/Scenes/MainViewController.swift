//
//  MainViewController.swift
//  PhotoZoomer
//
//  Created by Brian Sipple on 4/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        setupUIConstraints()
        updateZoomFor(size: view.bounds.size)
    }
}


// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / mainImageView.bounds.width
        let heightScale = size.height / mainImageView.bounds.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
    }
    
    
    func setupUIConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Keep the image view centered while zooming in and out
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor),
        ])
    }
}
