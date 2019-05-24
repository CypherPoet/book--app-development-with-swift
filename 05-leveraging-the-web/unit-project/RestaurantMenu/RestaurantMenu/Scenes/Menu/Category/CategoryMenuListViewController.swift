//
//  MenuListViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CategoryMenuListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var stateController: StateController!
    var modelController: CategoryMenuModelController!
    var dataSource: TableViewDataSource<MenuItem>!
}


// MARK: - Computed Properties

extension CategoryMenuListViewController {

    var category: MenuCategory {
        return modelController.category
    }
    
}


// MARK: - Lifecycle

extension CategoryMenuListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(stateController != nil, "No state controller was found")
        assert(modelController != nil, "No model controller was set")
        
        title = category.name.capitalized
        loadData()
    }
}


// MARK: - Navigation

extension CategoryMenuListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == R.segue.categoryMenuListViewController.showMenuItemDetailView.identifier,
            let menuItemDetailVC = segue.destination as? MenuItemDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let menuItem = dataSource.models[selectedIndexPath.row]
        
        menuItemDetailVC.viewModel = MenuItemDetailViewController.ViewModel(
            price: menuItem.price,
            itemName: menuItem.name,
            itemDescription: menuItem.details,
            itemImageURL: menuItem.imageURL
        )
        
        menuItemDetailVC.itemAddedToOrder = { [weak self] in
            self?.stateController.addItemToOrder(menuItem)
        }
    }
}


// MARK: - UITableViewDelegate

extension CategoryMenuListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var menuItem = dataSource.models[indexPath.row]
        
        guard menuItem.fetchedImage == nil else { return }
        
        modelController.fetchImage(for: menuItem) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    menuItem.fetchedImage = image
                case .failure(let error):
                    print("Error while attempting to fetch menu item image:\n\n\(error)")
                    menuItem.fetchedImage = menuItem.placeholderImage
                }
                
                self?.dataSource.models[indexPath.row] = menuItem
                self?.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}


// MARK: - Private Helper Methods

private extension CategoryMenuListViewController {
    
    func loadData() {
        modelController.loadMenuItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let menuItems):
                    self?.setupTableView(with: menuItems)
                case .failure(let error):
                    print("\(error)")
                    self?.display(alertMessage: "\(error)", titled: "Error while loading category menu items")
                }
            }
        }
    }
    
    
    func setupTableView(with menuItems: [MenuItem]) {
        let dataSource = TableViewDataSource(
            models: menuItems,
            cellReuseIdentifier: R.reuseIdentifier.menuItemCell.identifier,
            cellConfigurator: { (menuItem, cell) in
                cell.textLabel?.text = menuItem.name
                cell.detailTextLabel?.text = "\(menuItem.price) Sats"
                cell.imageView?.image = menuItem.fetchedImage ?? menuItem.placeholderImage
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        
        tableView.delegate = self
        tableView.reloadData()
    }
}
