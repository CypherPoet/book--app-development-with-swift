//
//  OptionsMenuDataSource.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class OptionsMenuTableViewDataSource: NSObject, UITableViewDataSource {
    var models: [OptionsMenuItem]
    var cellReuseIdentifier: String
    
    
    init(models: [OptionsMenuItem], cellReuseIdentifier: String) {
        self.models = models
        self.cellReuseIdentifier = cellReuseIdentifier
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            preconditionFailure("Failed to deque cell from table view")
        }
        
        let menuItem = models[indexPath.row]
        
        cell.textLabel?.text = menuItem.title
        cell.accessoryType = menuItem.hasDisclosureIndicator ? .disclosureIndicator : .none

        return cell
    }
}
