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
    var modelController: MenuModelController!
    var dataSource: TableViewDataSource<MenuItem>!
    
    var category: MenuCategory!
}



// MARK: - Lifecycle

extension CategoryMenuListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(stateController != nil, "No state controller was set")
        assert(modelController != nil, "No model controller was set")
        assert(category != nil, "No menu category was set")
        
        setupObservers()
        setupWithModelController()
    }
}


// MARK: - Navigation

extension CategoryMenuListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == R.segue.categoryMenuListViewController.showMenuItemDetail.identifier,
            let menuItemDetailVC = segue.destination as? MenuItemDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let menuItem = dataSource.models[selectedIndexPath.row]
        
        menuItemDetailVC.modelController = modelController
        menuItemDetailVC.viewModel = modelController.detailsViewModel(for: menuItem)
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: R.segue.categoryMenuListViewController.showMenuItemDetail.identifier,
            sender: self
        )
    }
}


// MARK: - Private Helper Methods

private extension CategoryMenuListViewController {
    
    func setupObservers() {
        defaultNotificationCenter.addObserver(
            self,
            selector: #selector(setupWithModelController),
            name: .MenuModelControllerDataUpdated,
            object: nil
        )
    }
    
    
    @objc func setupWithModelController() {
        title = category.name.capitalized
        
        let dataSource = TableViewDataSource(
            models: modelController.menuItems(for: category),
            cellReuseIdentifier: R.reuseIdentifier.menuItemTableCell.identifier,
            cellConfigurator: { (menuItem, cell) in
                guard let cell = cell as? MenuItemTableViewCell else {
                    preconditionFailure("Unknown cell type")
                }
                
                cell.viewModel = MenuItemTableViewCell.ViewModel(
                    itemTitle: menuItem.name,
                    itemPrice: menuItem.price,
                    thumbnailImage: menuItem.fetchedImage ?? menuItem.placeholderImage
                )
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        let cellNib = UINib(nibName: R.nib.menuItemTableViewCell.name, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: R.reuseIdentifier.menuItemTableCell.identifier)
        
        tableView.reloadData()
    }
}


extension CategoryMenuListViewController: AppNotifiable {}
