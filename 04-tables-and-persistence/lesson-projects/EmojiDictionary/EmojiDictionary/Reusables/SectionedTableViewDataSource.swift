//
//  SectionedTableViewDataSource.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SectionedTableViewDataSource: NSObject {
    private let dataSources: [UITableViewDataSource]
    private let sectionHeaderTitles: [String]
    
    
    init(dataSources: [UITableViewDataSource], sectionHeaderTitles: [String]) {
        self.dataSources = dataSources
        self.sectionHeaderTitles = sectionHeaderTitles
    }
}


extension SectionedTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        
        return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let dataSource = dataSources[indexPath.section]
        
        dataSource.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
}

