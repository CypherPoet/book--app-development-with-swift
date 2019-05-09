//
//  Date+pickerDisplayFormat.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension Date {
    var pickerDisplayFormat: String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
}
