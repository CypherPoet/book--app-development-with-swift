//
//  PickerViewDataSource.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PickerViewDataSource<Option>: NSObject, UIPickerViewDataSource {
    var options: [Option]
    var columnCount: Int
    var startWithBlank: Bool
    
    
    init(options: [Option], columnCount: Int = 1, startWithBlank: Bool = true) {
        self.options = options
        self.columnCount = columnCount
        self.startWithBlank = startWithBlank
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columnCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count + (startWithBlank ? 1 : 0)
    }
}
