//
//  UIViewController+AddAndRemove.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


@nonobjc extension UIViewController {
    func add(child childController: UIViewController, frame: CGRect? = nil) {
        addChild(childController)
        
        if let frame = frame {
            childController.view.frame = frame
        }
        
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    
    func handleRemoval() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
