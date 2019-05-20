//
//  TableViewDataSource.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//


import UIKit


class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias CellDeletionHandler = (Model, UITableViewCell, IndexPath) -> Void
    
    var models: [Model]
    
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator?
    private let cellDeletionHandler: CellDeletionHandler?
    
    
    init(
        models: [Model],
        cellReuseIdentifier: String,
        cellConfigurator: CellConfigurator? = nil,
        cellDeletionHandler: CellDeletionHandler? = nil
    ) {
        self.models = models
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.cellDeletionHandler = cellDeletionHandler
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let model = models[indexPath.row]
        
        cellConfigurator?(model, cell)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedModel = models.remove(at: sourceIndexPath.row)
        
        models.insert(movedModel, at: destinationIndexPath.row)
    }
    
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let model = models[indexPath.row]
        
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            cellDeletionHandler?(model, cell, indexPath)
        }
    }
}

