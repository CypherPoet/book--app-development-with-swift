//
//  StoreSearchListViewController.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class StoreSearchListViewController: UIViewController {
    @IBOutlet private weak var searchResultsTableView: UITableView!
    
    enum LoadingState {
        case inactive
        case loadingStoreItems
    }
    
    private var dataSource: TableViewDataSource<StoreItem>!
    
    private lazy var storeItemLoader = StoreItemLoader()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var loadingController = LoadingViewController()
    
    private var searchTask = DispatchWorkItem(block: {})
    private var searchScopes: [MediaType] = [.book, .podcast, .app, .music]
    
    private var currentLoadingState: LoadingState = .inactive {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.loadingStateChanged() }
        }
    }
}



// MARK: - Computed Properties

extension StoreSearchListViewController {
    
    var currentSearchText: String {
        return searchController.searchBar.text ?? ""
    }
    
    
    var hasSearchText: Bool {
        return !currentSearchText.isEmpty
    }
    
    
    var selectedMediaType: MediaType {
        let selectedScopeIndex = searchController.searchBar.selectedScopeButtonIndex
        
        guard selectedScopeIndex > -1 else {
            return .all
        }
        
        return searchScopes[selectedScopeIndex]
    }
}


// MARK: - Lifecycle

extension StoreSearchListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupSearchBar()
        setupResultsTable()
    }
}



// MARK: - Private Helper Methods

private extension StoreSearchListViewController {
    
    func performSearch(for term: String, in scope: MediaType) {
        currentLoadingState = .loadingStoreItems
        
        storeItemLoader.performSearch(for: term, in: scope) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.currentLoadingState = .inactive
                
                switch result {
                case .success(let storeItems):
                    self?.dataSource.models = storeItems.results
                    self?.searchResultsTableView.reloadData()
                case .failure(let error):
                    print(error)
                    self?.display(alertMessage: error.localizedDescription, title: "Error while fetching data")
                }
            }
        }
    }
    
    
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search the iTunes Store"
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.scopeButtonTitles = searchScopes.map { $0.searchScopeTitle }
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    
    func setupResultsTable() {
        let dataSource = TableViewDataSource(
            models: [StoreItem](),
            cellReuseIdentifier: R.reuseIdentifier.storeItemCell.identifier,
            cellConfigurator: { [weak self] (storeItem, cell) in
                guard let storeItemCell = cell as? StoreItemTableViewCell else {
                    preconditionFailure("Unknown cell dequeued from table")
                }
                
                self?.configure(storeItemCell, with: storeItem)
            }
        )
        
        self.dataSource = dataSource
        searchResultsTableView.dataSource = dataSource
        searchResultsTableView.delegate = self
    }
    
    
    func configure(_ storeItemCell: StoreItemTableViewCell, with storeItem: StoreItem) {
        storeItemCell.viewModel = StoreItemTableCellViewModel(
            title: storeItem.trackName ?? storeItem.collectionName ?? "",
            subtitle: storeItem.description ?? storeItem.collectionName ?? "",
            thumbnailImage: storeItem.artworkImage ?? storeItem.placeholderImage
        )
    }
}


// MARK: - UITableViewDelegate

extension StoreSearchListViewController: UITableViewDelegate {
    
    /**
     If the "real" image hasn't been fetched yet, we'll do it now that the cell is actually being shown.
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var storeItem = dataSource.models[indexPath.row]
        
        if storeItem.artworkImage != nil {
            return
        }
        
        URLSession.shared.load(with: URLRequest(url: storeItem.artworkURL)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    storeItem.artworkImage = UIImage(data: data)
                    
                    self?.dataSource.models[indexPath.row] = storeItem
                    self?.searchResultsTableView.reloadRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print("Error while attempting to fetch store item image:\n\(error.localizedDescription)")
                }
            }
        }
    }
}


// MARK: - UISearchBarDelegate

extension StoreSearchListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard hasSearchText else { return }

        performSearch(for: currentSearchText, in: selectedMediaType)
    }
}


// MARK: - Delegate

extension StoreSearchListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard hasSearchText else { return }
        
        let searchTerm = currentSearchText
        let scope = selectedMediaType
        
        searchTask.cancel()
        searchTask = DispatchWorkItem { [weak self] in
            self?.performSearch(for: searchTerm, in: scope)
        }
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.25, execute: searchTask)
    }
    
    
    func loadingStateChanged() {
        switch currentLoadingState {
        case .loadingStoreItems:
            add(child: loadingController)
        case .inactive:
            loadingController.performRemoval()
        }
    }
}
