//
//  PickerViewDataSource.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PickerViewDataSource<Option>: NSObject, UIPickerViewDataSource {
    var options: [Option]
    var columnCount: Int
    
    
    init(options: [Option], columnCount: Int = 1) {
        self.options = options
        self.columnCount = columnCount
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columnCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}
