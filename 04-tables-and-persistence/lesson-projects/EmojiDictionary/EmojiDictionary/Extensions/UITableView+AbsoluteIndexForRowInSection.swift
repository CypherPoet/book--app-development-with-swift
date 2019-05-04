//
//  TableView+AbsoluteIndex.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension UITableView {
    
    func absoluteIndex(forRow row: Int, inSection section: Int) -> Int {
        let rowsBeforeSection = (0..<section).reduce(0, { (rowCount, currentSection) -> Int in
            return rowCount + self.numberOfRows(inSection: currentSection)
        })
        
        return rowsBeforeSection + row
    }
}

