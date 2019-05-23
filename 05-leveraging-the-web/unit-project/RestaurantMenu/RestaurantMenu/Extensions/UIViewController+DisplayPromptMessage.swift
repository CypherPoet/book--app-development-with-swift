//
//  UIViewController+DisplayPromptMessage.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    func display(
        promptMessage: String,
        titled title: String = "",
        confirmButtonTitle: String = "OK",
        cancelButtonTitle: String = "Cancel",
        confirmationHandler: ((UIAlertAction) -> Void)? = nil,
        cancelationHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: promptMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: confirmButtonTitle, style: .default, handler: confirmationHandler)
        )
        
        alertController.addAction(
            UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelationHandler)
        )
        
        present(alertController, animated: true)
    }
}

