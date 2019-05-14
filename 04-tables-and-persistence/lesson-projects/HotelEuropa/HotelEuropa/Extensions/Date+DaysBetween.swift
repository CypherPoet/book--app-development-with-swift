//
//  Date+DaysBetween.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension Date {
    func daysBetween(_ otherDate: Date) -> Int {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: self)
        let endDay = calendar.startOfDay(for: otherDate)
        
        let comparisonComponents = calendar.dateComponents(
            [.day],
            from: startDay,
            to: endDay
        )
        
        guard let days = comparisonComponents.day else {
            fatalError("Unable to compute number of days between \(self) and \(otherDate).")
        }
        
        return days
    }
}
