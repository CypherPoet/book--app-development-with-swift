//
//  PendingOrderListViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PendingOrderListViewController: UIViewController {
    
    lazy var apiClient: APIClient = {
        let transport = HeaderedTransport(
            baseTransport: URLSession.shared,
            headers: ["application/json": "Content-Type"]
        )
        
        return APIClient(transport: transport)
    }()
}


// MARK: - Lifecycle

extension PendingOrderListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


// MARK: - Private Helper Methods

private extension PendingOrderListViewController {
    
    func place(_ order: Order) {
        guard
            let orderData = try? JSONEncoder().encode(order),
            let url = URL(string: Order.baseURL)
        else {
            preconditionFailure("Failed to make data for post")
        }
        
        let prepTimeResource = APIResource<PreparationTime>(to: url, with: orderData)
        
        apiClient.sendRequest(for: prepTimeResource) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let prepTime):
                    print("Prep time: \(prepTime.seconds)")
                case .failure(let error):
                    self?.display(alertMessage: "\(error)", title: "Error while submitting order.")
                }
            }
        }
        
    }
    
}
