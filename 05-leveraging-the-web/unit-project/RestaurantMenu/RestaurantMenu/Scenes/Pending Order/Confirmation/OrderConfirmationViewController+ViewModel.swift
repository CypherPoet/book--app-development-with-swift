//
//  OrderConfirmationViewController+ViewModel.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


extension OrderConfirmationViewController {
    
    struct ViewModel {
        var confirmationResult: String
        var resultDescription: String
        var preparationTime: Int?
    }
}


// MARK: - Initializer

extension OrderConfirmationViewController.ViewModel {
    
    init(
        confirmationResult: String,
        resultDescription: String
    ) {
        self.confirmationResult = confirmationResult
        self.resultDescription = resultDescription
        self.preparationTime = nil
    }
}


// MARK: - Computed Properties

extension OrderConfirmationViewController.ViewModel {
    
    var preparationTimeText: String? {
        guard let prepTimeMinutes = preparationTime else {
            return nil
        }
        
        return "Estimated Prep Time: \(prepTimeMinutes) minutes"
    }
    
}
