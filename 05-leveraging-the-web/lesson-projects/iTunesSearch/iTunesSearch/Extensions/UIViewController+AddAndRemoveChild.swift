//
//  UIViewController+AddAndRemoveChild.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    func add(
        child childViewController: UIViewController,
        toView targetView: UIView? = nil,
        usingFrame customFrame: CGRect? = nil
    ) {
        let targetView = targetView ?? view
        
        childViewController.view.frame = customFrame ?? childViewController.view.frame
        
        addChild(childViewController)
        targetView?.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    
    func performRemoval() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
