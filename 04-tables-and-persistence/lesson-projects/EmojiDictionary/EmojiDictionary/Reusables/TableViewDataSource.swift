//
//  TableViewDataSource.swift
//
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    
    init(
        models: [Model],
        cellReuseIdentifier: String,
        cellConfigurator: @escaping CellConfigurator
    ) {
        self.models = models
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
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
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedModel = models.remove(at: sourceIndexPath.row)
        
        models.insert(movedModel, at: destinationIndexPath.row)
    }
}
