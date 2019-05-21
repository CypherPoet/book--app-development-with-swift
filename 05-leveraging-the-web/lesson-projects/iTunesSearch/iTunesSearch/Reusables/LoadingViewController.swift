//
//  LoadingViewController.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSpinner()
    }

}


// MARK: - Private Helper Methods

private extension LoadingViewController {
    
    func setupUI() {
        view.backgroundColor = .black
        view.alpha = 0.25
    }
    
    func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        
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
