//
//  LoadingViewController.swift
//  NASAAstronomyPhotos
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSpinner()
    }

}


// MARK: - Private Helper Methods

private extension LoadingViewController {
    
    func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: .gray)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        view.addSubview(spinner)
        
        // Fix the spinner to the center of the view
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
