//
//  TableViewDataSource.swift
//
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias ModelDeleter = ((Model, Int) -> Void)?
    
    var models: [Model]
    
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    private let modelDeleter: ModelDeleter
    
    
    init(
        models: [Model],
        cellReuseIdentifier: String,
        cellConfigurator: @escaping CellConfigurator,
        modelDeleter: ModelDeleter = nil
    ) {
        self.models = models
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.modelDeleter = modelDeleter
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = models[indexPath.row]
            
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            modelDeleter?(model, tableView.absoluteIndex(forRow: indexPath.row, inSection: indexPath.section))
        }
    }
}
