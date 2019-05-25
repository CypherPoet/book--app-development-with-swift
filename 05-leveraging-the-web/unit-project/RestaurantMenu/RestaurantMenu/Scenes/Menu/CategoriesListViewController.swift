//
//  CategoriesListViewController.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CategoriesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var stateController: StateController!
    var modelController: MenuModelController!
    
    var dataSource: TableViewDataSource<MenuCategory>!
    lazy var apiClient: APIClient = APIClient()
}


// MARK: - Lifecycle

extension CategoriesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(stateController != nil, "No state controller was set")
        assert(modelController != nil, "No model controller was set")

        setupObservers()
        setupWithModelController()
    }
}


// MARK: - Navigation

extension CategoriesListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == R.segue.categoriesListViewController.showCategoryMenu.identifier,
            let categoryMenuVC = segue.destination as? CategoryMenuListViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let category = dataSource.models[selectedIndexPath.row]
        
        categoryMenuVC.stateController = stateController
        categoryMenuVC.modelController = modelController
        categoryMenuVC.category = category
    }
}



// MARK: - Private Helper Methods

private extension CategoriesListViewController {
    
    func setupObservers() {
        defaultNotificationCenter.addObserver(
            self,
            selector: #selector(setupWithModelController),
            name: .MenuModelControllerDataUpdated,
            object: nil
        )
    }
    
    
    @objc func setupWithModelController() {
        let dataSource = TableViewDataSource(
            models: modelController.categories,
            cellReuseIdentifier: R.reuseIdentifier.categoryCell.identifier,
            cellConfigurator: { (category, cell) in
                cell.textLabel?.text = category.name.capitalized
            }
        )
        
        self.dataSource = dataSource
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension CategoriesListViewController: AppNotifiable {}
