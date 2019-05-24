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
    
    var confirmationResult: Result<PreparationTime, Error>?
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

        navigationItem.leftBarButtonItem = editButtonItem
        setupTableView()
        setupNotificationListeners()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
}


// MARK: - Event handling

extension PendingOrderListViewController {
    
    @objc func currentOrderUpdated() {
        dataSource.models = currentOrder.menuItems
        tableView.reloadData()
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
        promptToConfirmSubmit()
    }
}


// MARK: - Navigation

extension PendingOrderListViewController {
    
    @IBAction func unwindFromOrderConfirmation(segue: UIStoryboardSegue) {
        guard
            segue.identifier == R.segue.orderConfirmationViewController.unwindFromOrderConfirmation.identifier
        else { return }
        
        stateController.clearOrder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == R.segue.pendingOrderListViewController.presentOrderConfirmationView.identifier,
            let orderConfirmationVC = segue.destination as? OrderConfirmationViewController,
            let confirmationResult = confirmationResult
        else { return }
        
        var viewModel: OrderConfirmationViewController.ViewModel
        
        switch confirmationResult {
        case .success(let prepTime):
            viewModel = OrderConfirmationViewController.ViewModel(
                confirmationResult: "Success!",
                resultDescription: "Your order is underway",
                preparationTime: prepTime.minutes
            )
        case .failure:
            viewModel = OrderConfirmationViewController.ViewModel(
                confirmationResult: "Uh-oh",
                resultDescription: "We were unable to place your order at this time. Please try again later."
            )
        }
        
        orderConfirmationVC.viewModel = viewModel
    }
    
}


// MARK: - UITableViewDelegate

extension PendingOrderListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var menuItem = dataSource.models[indexPath.row]
        
        guard menuItem.fetchedImage == nil else { return }
        
        let urlRequest = URLRequest(url: menuItem.imageURL)
        
        URLSession.shared.send(request: urlRequest) { [weak self] dataResult in
            DispatchQueue.main.async {
                menuItem.setFetchedImage(with: dataResult)
                
                self?.dataSource.models[indexPath.row] = menuItem
                self?.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



// MARK: - Private Helper Methods

private extension PendingOrderListViewController {
    
    func setupTableView() {
        let dataSource = TableViewDataSource(
            models: currentOrder.menuItems,
            cellReuseIdentifier: R.reuseIdentifier.menuItemTableCell.identifier,
            canMoveCells: false,
            cellConfigurator: { (menuItem, cell) in
                guard let cell = cell as? MenuItemTableViewCell else {
                    preconditionFailure("Unknown cell type")
                }
                
                cell.viewModel = MenuItemTableViewCell.ViewModel(
                    itemTitle: menuItem.name,
                    itemPrice: menuItem.price,
                    thumbnailImage: menuItem.fetchedImage ?? menuItem.placeholderImage
                )
                
                cell.accessoryType = .none
            },
            cellDeletionHandler: { [weak self] (_, _, indexPath) in
                self?.stateController.removeItemFromOrder(at: indexPath.row)
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource

        tableView.delegate = self
        
        let cellNib = UINib(nibName: R.nib.menuItemTableViewCell.name, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: R.reuseIdentifier.menuItemTableCell.identifier)
        
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
    
    
    @objc func placeOrder() {
        let menuData = stateController.currentOrder.asPostableMenuData
        
        guard
            let orderData = try? JSONEncoder().encode(menuData),
            let url = URL(string: Order.baseURL)
        else {
            preconditionFailure("Failed to make data for post")
        }
        
        let prepTimeResource = APIResource<PreparationTime>(to: url, with: orderData)
        
        apiClient.sendRequest(for: prepTimeResource) { [weak self] result in
            self?.confirmationResult = result
            
            DispatchQueue.main.async {
                self?.performSegue(
                    withIdentifier: R.segue.pendingOrderListViewController.presentOrderConfirmationView.identifier,
                    sender: self
                )
            }
        }
    }
    
    
    func promptToConfirmSubmit() {
        let orderTotal = stateController.currentOrder.totalPrice
        let message = "You are about to place an order for a price of \(orderTotal) sats."
       
        display(
            promptMessage: message,
            titled: "Confirm Order",
            confirmButtonTitle: "Submit",
            confirmationHandler: { action in
                self.placeOrder()
            }
        )
    }
}
