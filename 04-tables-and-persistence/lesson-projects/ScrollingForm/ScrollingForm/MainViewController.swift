//
//  MainViewController.swift
//  ScrollingForm
//
//  Created by Brian Sipple on 4/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!

    lazy var notificationCenter = NotificationCenter.default
    
    private let keyboardChangeNotificationNames = [
        UIResponder.keyboardWillChangeFrameNotification,
        UIResponder.keyboardWillHideNotification,
    ]
}


// MARK: - Lifecycle

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUIConstraints()
        setupObservers()
    }
}


// MARK: - Event handling

extension MainViewController {
    @objc func keyboardDidMove(notification: NSNotification) {
        if let contentInsets = edgeInsetsFromKeyboardChange(notification) {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func setupUIConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor),
        ])
    }

    
    func setupObservers() {
        keyboardChangeNotificationNames.forEach { notificationName in
            notificationCenter.addObserver(
                self,
                selector: #selector(keyboardDidMove(notification:)),
                name: notificationName,
                object: nil
            )
        }
    }
}

