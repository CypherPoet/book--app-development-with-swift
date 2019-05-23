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
    
    var dataSource: TableViewDataSource<MenuCategory>!
    lazy var apiClient: APIClient = APIClient()
}


// MARK: - Lifecycle

extension CategoriesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(stateController != nil, "No state controller was found")

        loadData()
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
        categoryMenuVC.modelController = CategoryMenuModelController(category: category)
    }
}



// MARK: - Private Helper Methods

extension CategoriesListViewController {
    
    private func loadData() {
        let categoriesResource = APIResource<CategoryList>(from: URL(string: CategoryList.baseURL)!)

        apiClient.sendRequest(for: categoriesResource) { result in
            switch result {
            case .success(let categoryList):
                DispatchQueue.main.async { [weak self] in
                    self?.setupDataSource(with: categoryList)
                }
            case .failure(let error):
                fatalError("Error while attempting to load categoryList: \(error)")
            }
        }
    }
    
    
    private func setupDataSource(with categoryList: CategoryList) {
        let dataSource = TableViewDataSource(
            models: categoryList.categories,
            cellReuseIdentifier: R.reuseIdentifier.categoryCell.identifier,
            cellConfigurator: { (model, cell) in
                cell.textLabel?.text = model.name.capitalized
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
