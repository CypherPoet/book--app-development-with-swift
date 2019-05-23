//
//  PendingOrderListViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PendingOrderListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var stateController: StateController!
    var dataSource: TableViewDataSource<MenuItem>!
    
    lazy var apiClient: APIClient = {
        let transport = HeaderedTransport(
            baseTransport: URLSession.shared,
            headers: ["application/json": "Content-Type"]
        )
        
        return APIClient(transport: transport)
    }()
}


// MARK: - Computed Properties

extension PendingOrderListViewController {
    
    var currentOrder: Order {
        return stateController.currentOrder
    }
    
}


// MARK: - Lifecycle

extension PendingOrderListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(stateController != nil, "No state controller was found")
        
        setupTableView()
        setupNotificationListeners()
    }
}


// MARK: - Event handling

extension PendingOrderListViewController {
    
    @objc func currentOrderUpdated() {
        dataSource.models = currentOrder.menuItems
        tableView.reloadData()
    }
}


// MARK: - Private Helper Methods

private extension PendingOrderListViewController {
    
    func setupTableView() {
        let dataSource = TableViewDataSource(
            models: currentOrder.menuItems,
            cellReuseIdentifier: R.reuseIdentifier.pendingOrderTableCell.identifier,
            cellConfigurator: { (menuItem, cell) in
                cell.textLabel?.text = menuItem.name
                cell.detailTextLabel?.text = "\(menuItem.price) sats"
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    
    func setupNotificationListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(currentOrderUpdated),
            name: .StateControllerOrderUpdated,
            object: nil
        )
    }
    
    
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
